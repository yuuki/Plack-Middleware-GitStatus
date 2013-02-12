use strict;
use warnings;

use Test::More;
use Plack::Test;

use Plack::Builder;
use Plack::Middleware::GitStatus;

subtest builder => sub {
    my $app = builder {
        enable 'GitStatus', path => '/git-status';
        sub { [200, [ 'Content-Type' => 'text/plain' ], [ "Hello World" ]] };
    };

    test_psgi app => $app, client => sub {
        my $cb = shift;
        my $req = HTTP::Request->new(GET => "http://localhost/git-status");
        my $res = $cb->($req);
        like $res->content, qr/CurrentBranch:/;
    };
};

done_testing;
