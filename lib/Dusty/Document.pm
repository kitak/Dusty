package Dusty::Document;
use strict;
use warnings;
use base qw/Class::Accessor::Lvalue::Fast/;

__PACKAGE__->mk_accessors(qw/title content url id/);

use Encode qw/encode_utf8 decode_utf8/;
use Dusty::Model;

our $db = Dusty::Model->new(connect_info => [
    'DBI:mysql:database=dusty;host=localhost;',
    'root',
    '',
    {mysql_enable_utf8=>1,}
]);

sub save {
    my $self = shift;
    $db->insert('documents', {
        url => $self->url,
        title => $self->title,
        content => $self->content,
    });
};

sub find {
    my ($self, $id) = @_;
    my $row = $db->single('documents', {'id' => $id});
    my $doc = Dusty::Document->new;
    $doc->id = $row->id;
    $doc->url = $row->url;
    $doc->title = decode_utf8($row->title);
    $doc->content = decode_utf8($row->content);

    return $doc;
};

1;
