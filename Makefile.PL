use inc::Module::Install;
name 'ListPod-App-Lite';
all_from 'lib/ListPod/App/Lite.pm';

requires 'LWP::UserAgent';
requires 'Text::MicroTemplate';
requires 'Plack::Runner';
requires 'Plack::Request';
requires 'XML::Feed';
requires 'Pod::Usage';
requries 'Getopt::Long';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
