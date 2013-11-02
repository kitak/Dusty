requires 'perl', '5.008001';
requires 'YAML';
requires 'HTML::ExtractContent';
requires 'HTTP::Response::Encoding';
requires 'LWP::Protocol::https';
requires 'Teng';
requires 'Teng::Schema::Loader';
requires 'DBD::mysql';
requires 'Class::Accessor::Lvalue::Fast';
requires 'Redis::Client';
requires 'FindBin';
# from carton v1.1
#requires 'git@github.com:kiririmode/p5-WebService-Pocket-Lite.git';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

