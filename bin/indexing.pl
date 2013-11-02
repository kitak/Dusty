#!/usr/bin/env perl
use strict;
use warnings;
use utf8;

use Dusty::Index;
use Dusty::Document;

my $index = Dusty::Index->new;


my $db = Dusty::Model->new(connect_info => [
    'DBI:mysql:database=dusty;host=localhost;',
    'root',
    '',
    {mysql_enable_utf8=>1,}
]);
my $doc_rows = $db->search("documents", {});
while (my $doc = $doc_rows->next) {
    $index->add_document($doc);
}
