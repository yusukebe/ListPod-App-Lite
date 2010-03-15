use inc::Module::Install;
name 'ListPod-App-Lite';
all_from 'lib/ListPod/App/Lite.pm';

requires 'LWP::UserAgent';
requires 'Text::MicroTemplate';
requires 'Plack::Runner';
requires 'Plack::Request';
requires 'Pod::Usage';
requires 'Getopt::Long';

recommends 'AnyEvent';
recommends 'AnyEvevt::HTTP';

install_script('bin/listpod-app-lite');

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
