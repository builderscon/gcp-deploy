use strict;

sub {
    my $env = shift;
    if ($env->{HTTP_USER_AGENT} =~ /GoogleHC/) {
        return [200, [], []]
    }

    if ($env->{HTTP_HOST} !~ /^(\d+\.[^\.]+)\.builderscon.io/) {
        return [404, [], []]
    }

    my $path = join '/', reverse split /\./, $1;
    if ($path == 'tokyo/2016') {
        return [301, ['Location' => "https://builderscon.io/builderscon/$path"], []]
    } else {
        return [301, ['Location' => "https://builderscon.io/$path"], []]
    }
}