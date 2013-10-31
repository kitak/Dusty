use strict;
use warnings;
use utf8;

use Encode qw/encode decode/;
use Encode::Guess;
use LWP::UserAgent;
use HTML::ExtractContent;
use HTTP::Response::Encoding;

my $url = 'http://kitak.hatenablog.jp/entry/2013/10/27/173431';

my $agent = LWP::UserAgent->new;
my $res = $agent->get($url);

if ($res->is_error) {
    die $res->status_line;
}

my $enc = $res->encoding;
if (!$enc) {
    $enc = guess_encoding($res->content, qw/cp932 enc-jp iso-2022-jp utf8 shiftjis/);
}
my $html = decode($enc, $res->content);

my $ext = HTML::ExtractContent->new;
$ext->extract($html);
print encode('UTF-8', $ext->as_text);
