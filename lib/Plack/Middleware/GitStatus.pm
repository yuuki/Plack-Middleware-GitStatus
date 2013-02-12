package Plack::Middleware::GitStatus;
use strict;
use warnings;
our $VERSION = '0.01';

use parent 'Plack::Middleware';
use Plack::Util::Accessor qw(path git_dir);
use Plack::Util;

use Cwd;
use Git::Repository 'Log';
use Time::Piece;
use Try::Tiny;

our $WORKTREE;

sub prepare_app {
    my $self = shift;
    $WORKTREE = Git::Repository->new(work_tree => $self->{git_dir} || getcwd);
}

sub call {
    my ($self, $env) = @_;

    if ($self->path && $env->{PATH_INFO} eq $self->path) {
        my $brach_name = $self->_current_branch;
        my $last_commit = $self->_last_commit;

        my $body  = "CurrentBranch: $brach_name\n";
           $body .= sprintf "Commit: %s\n",  $last_commit->{commit};
           $body .= sprintf "Author: %s\n",  $last_commit->{author};
           $body .= sprintf "Date: %s\n",    $last_commit->{date};
           $body .= sprintf "Message: %s", $last_commit->{message};
        return [200, ['Content-Type' => 'text/plain'], [ $body ]];
    }

    return $self->app->($env);
}

sub _current_branch {
    my $self = shift;
    my (@lines) = $WORKTREE->run('status');
    $lines[0] =~ /branch (.+)$/;
    return $1;
}

sub _last_commit {
    my $self = shift;

    my ($log) = Git::Repository->log('-1');
    return +{
        commit  => $log->commit,
        author  => $log->author,
        message => $log->message,
        date    => _unixtime_to_date($log->author_localtime),
    };
}

sub _unixtime_to_date {
    my $lt = localtime($_[0]);
    my $t = gmtime($lt->epoch);
    return $t;
}

1;
__END__

=head1 NAME

Plack::Middleware::GitStatus - Provide Git status via HTTP

=head1 SYNOPSIS

    use Plack::Builder;

    builder {
        enable "Plack::Middleware::GitStatus",
            path  => '/git-status',
        $app;
    };

    % curl http://server:port/git-status
    CurrentBranch: feature/something-interesting
    Commit: a7c24106ac453c10f1a460f52e95767803076dde
    Author: y_uuki
    Date: Tue Feb 12 06:06:41 2013 +0900

=head1 DESCRIPTION

Plack::Middleware::GitStatus provides via HTTP Git status like current branch, last commit, and so on.

=head1 AUTHOR

Yuuki Tsubouchi E<lt>yuuki@cpan.orgE<gt>

=head1 SEE ALSO

L<Plack::Middleware::ServerStatus>
L<Plack::Middleware::ServerStatus::Lite>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
