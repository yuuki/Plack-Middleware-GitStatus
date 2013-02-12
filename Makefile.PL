use inc::Module::Install;
name 'Plack-Middleware-GitStatus';
all_from 'lib/Plack/Middleware/GitStatus.pm';

requires 'Git::Repository';
requires 'parent';
requires 'Plack';
requires 'Time::Piece'; # standard module 5.10 and over
requires 'Try::Tiny';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
