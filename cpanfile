requires 'Cache::Cache', 1.06;
requires 'Git::Repository', 1.301;
requires 'Plack';
requires 'Time::Piece';
requires 'Try::Tiny';
requires 'parent';

on build => sub {
    requires 'ExtUtils::MakeMaker', '6.36';
    requires 'File::Temp';
    requires 'File::Which';
    requires 'Test::More';
};
