use inc::Module::Install;
name 'ListPod-App-Lite';
all_from 'lib/ListPod/App/Lite.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
