use strict;
use warnings;
use utf8;
use Encode 'encode';
use YAML;
use FindBin;
use WebService::Pocket::Lite;

my $config = YAML::LoadFile("$FindBin::Bin/../../config.yml");

my $pocket = WebService::Pocket::Lite->new(
  consumer_key => $config->{pocket}->{consumer_key},
  access_token => $config->{pocket}->{access_token},
);

my $res = $pocket->retrieve({state => 0, since => time - 24*3600});
if ($res->{status} == 1) {
    my %list = %{$res->{list}};
    for my $id (keys %list){
        my $item = $list{$id};
        print encode('UTF-8', $item->{resolved_title});
        print $item->{resolved_url};
    }
}
