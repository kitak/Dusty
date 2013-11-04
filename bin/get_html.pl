use strict;
use warnings;
use utf8;
use Encode;
use Encode::Guess;
use LWP::UserAgent;
use HTML::ExtractContent;
use HTTP::Response::Encoding;
use Dusty::Document;
use YAML;
use FindBin;
use WebService::Pocket::Lite;

my $day_ago = shift || 1;
my $agent = LWP::UserAgent->new;
my $ext = HTML::ExtractContent->new;
my @crawl_lists = crawl_lists_from_pocket($day_ago);

for my $item (@crawl_lists){
    my $res = $agent->get($item->{url});

    if (!$res->is_error) {
        my $enc = $res->encoding;
        if (!$enc) {
            $enc = guess_encoding($res->content, qw/cp932 enc-jp iso-2022-jp utf8 shiftjis/);
        }
        my $html = decode($enc, $res->content);
        my $doc = Dusty::Document->new;
        $doc->title = $item->{title};
        $doc->url = $item->{url};
        $doc->content = ($ext->extract($html))->as_text;
        $doc->save();
    }
}

sub crawl_lists_from_pocket {
    my $day_ago = shift;
    my $config = YAML::LoadFile("$FindBin::Bin/../config.yml");
    my $pocket = WebService::Pocket::Lite->new(
        consumer_key => $config->{pocket}->{consumer_key},
        access_token => $config->{pocket}->{access_token},
    );
    my @crawl_lists = ();

    my $res = $pocket->retrieve({state => 0, since => time - $day_ago*24*3600});
    if ($res->{status} == 1) {
        my %list = %{$res->{list}};
        for my $id (keys %list){
            my $item = $list{$id};
            push @crawl_lists, {
                title => decode_utf8($item->{resolved_title}),
                url => $item->{resolved_url}
            };
        }
    }

    return @crawl_lists;
}
