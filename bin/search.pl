#!/usr/bin/env perl
use strict;
use warnings;
use Encode 'decode_utf8';
use Dusty::Index;

my $word = shift or die "usage: $0 <word>";

my $index = Dusty::Index->new;
for my $doc ($index->retrieve_documents(decode_utf8($word))) {
    my $id = $doc->id;
    my $url = $doc->url;
    print "[$id] $url\n";
}
