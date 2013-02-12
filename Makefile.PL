use inc::Module::Install;
name 'Plack-Middleware-GitStatus';
all_from 'lib/Plack/Middleware/GitStatus.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
