#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use Encode;
use Dusty::Util;

my @words = ngram("ぼうやよい子やねんねしや");

for my $word (@words){
    print encode_utf8($word);
}
