use strict;
use Test::More;

use_ok('ListPod::App::Lite::UserAgent');
my $ua = ListPod::App::Lite::UserAgent->new;
ok( $ua, 'Make instance' );
my $res = $ua->get('http://www.youtube.com/');
ok( $res, 'Res is OK??' );

done_testing;
