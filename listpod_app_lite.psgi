use strict;
use ListPod::App::Lite;

my $cookie_file = $ENV{COOKIE_FILE};
my $app = ListPod::App::Lite->new( cookie_file => $cookie_file );
return $app->handler;
