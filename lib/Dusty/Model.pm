package Dusty::Model;
use strict;
use warnings;
use parent 'Teng';
1;

package Dusty::Model::Schema;
use Teng::Schema::Declare;

table {
    name 'documents';
    pk 'id';
    columns qw(id title url content);
};
1;
