use strict;
use warnings;
use Dusty::Model;

my $teng = Dusty::Model->new(connect_info => [
    'DBI:mysql:database=dusty;host=localhost;',
    'root',
    '',
    {mysql_enable_utf8=>1,}
]);

my $row = $teng->insert('documents', {
    url => 'a',
    title => 'b',
    content => 'c',
});
