use strict;

sub {
    my $env = shift;
    if ($env->{HTTP_USER_AGENT} =~ /GoogleHC/) {
        return [200, [], []]
    }

    if ($env->{HTTP_HOST} !~ /^(\d+\.[^\.]+)\.builderscon.io/) {
        return [404, [], []]
    }

    return [301, ['Location' => "https://builderscon.io/builderscon/" . join '/', reverse split /\./, $1], []]
}