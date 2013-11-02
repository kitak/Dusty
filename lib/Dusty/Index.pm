package Dusty::Index;
use strict;
use warnings;
use utf8;
use base qw/Class::Accessor::Lvalue::Fast/;
use Encode;
use Dusty::Document;
use Dusty::Util;
use Redis::Client;

__PACKAGE__->mk_accessors(qw/redis_client/);

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(@_);
    $self->redis_client = Redis::Client->new(host => 'localhost', port => 6379);
    return $self;
}

sub add_document {
    my ($self, $doc) = @_;

    my @words = ngram(
        lc(join("\n", $doc->title, $doc->url, $doc->content))
    );

    my %seen;
    for my $w (@words) {
        if (not $seen{$w}++) {
            $self->add($w => $doc->id);
        }
    }
}

sub add {
    my ($self, $w, $doc_id) = @_;
    $self->redis_client->rpush(encode_utf8("dusty_".$w) => $doc_id);
    return $doc_id;
}

sub retrieve_documents {
    my $self = shift;
    my @ids = $self->retrieve(@_) or return;
    my @documents = map { Dusty::Document->find($_) } @ids;
    return sort_documents(\@documents);
}

sub retrieve {
    my ($self, $q) = @_;

    my @postings = ();
    for my $qt (split /\s+/, $q) {
        for my $w (ngram(lc($qt))) {
            if (my $p = $self->get_postings($w)) {
                push @postings, $p;
            } else {
                # ヒットなし
                return;
            }
        }
    }

    @postings = sort { @$a <=> @$b } @postings;

    my $p = shift @postings;
    while (@postings > 0 && defined $p) {
        $p = intersect($p, shift @postings);
    }

    @$p > 0 ? return @$p : return;
}

sub get_postings {
    my ($self, $w) = @_;
    my @ids = $self->redis_client->lrange(encode_utf8('dusty_'.$w), 0, -1);
    return \@ids;
}

sub sort_documents {
    my $docs = shift;
    return sort {$b->id <=> $a->id} @$docs;
}

1;
