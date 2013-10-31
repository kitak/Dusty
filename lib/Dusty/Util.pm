package Dusty::Util;
use strict;
use warnings;
use utf8;
use Encode;
use base 'Exporter';

our @EXPORT = qw/ngram byte_lc intersect/;

sub ngram {
    my ($str, $n) = @_;
    $n ||= 2;

    my $len = length $str;
    if ($len < $n) {
        return $str;
    }

    my @words;
    for my $i (0..($len - $n)) {
        push @words, substr($str, $i, $n);
    }

    return @words;
}

sub byte_lc {
    use bytes;
    return lc shift;
}

sub intersect {
    my ($p1, $p2) = @_;
    my $answer = [];

    my $i = 0;
    my $j = 0;

    while (defined $p1->[$i] && defined $p2->[$j]) {
        if ($p1->[$i] == $p2 ->[$j]) {
            push @$answer, $p1->[$i];
            $i += 1;
            $j += 1;
        } else {
            $p1->[$i] < $p2->[$j] ? $i++ : $j++;
        }
    }

}

1;
