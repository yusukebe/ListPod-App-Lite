use strict;
use Test::More;
use ListPod::App::Lite::UserAgent;

use_ok('ListPod::App::Lite::YouTube');
my $ua = ListPod::App::Lite::UserAgent->new;
my $youtube = ListPod::App::Lite::YouTube->new( ua => $ua );
ok( $youtube, 'Make instance' );
my $playlist = $youtube->playlist('C03083BF9A5A0418'); #perfume;
is( ref $playlist, 'HASH', 'plyalist is HASH');
use Data::Dumper;
print Dumper $playlist;
done_testing;
