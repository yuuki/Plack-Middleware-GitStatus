use inc::Module::Install;
name 'Plack-Middleware-GitStatus';
all_from 'lib/Plack/Middleware/GitStatus.pm';

requires 'Git::Repository';
requires 'parent';          # standard 5.10 and over
requires 'Plack';
requires 'Time::Piece';     # standard 5.10 and over
requires 'Try::Tiny';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
test_requires 'File::Temp'; # standard 5.6.1 and over
test_requires 'File::Which';

auto_set_repository;
auto_include;
WriteAll;
