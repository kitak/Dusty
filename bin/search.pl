#!/usr/bin/env perl
use strict;
use warnings;
use Dusty::Index;

my $word = shift or die "usage: $0 <word>";

my $index = Dusty::Index->new;
for my $doc ($index->retrieve_documents($word)) {
    my $id = $doc->id;
    my $url = $doc->url;
    print "[$id] $url\n";
}
