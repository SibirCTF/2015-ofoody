#!/usr/bin/env perl
#==============================================================================
#
#         FILE: checker.pl
#
#        USAGE: ./checker.pl cmd hostname ccn username password address review
#
#  DESCRIPTION: O'Foody service checker
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Vladislav A. Retivykh (var), firolunis@riseup.net
# ORGANIZATION: keva
#      VERSION: 0.2
#      CREATED: 05/21/2015 08:44:35 AM
#     REVISION: ---
#==============================================================================

use strict;
use warnings FATAL => 'all';
use utf8;

use LWP::UserAgent;

my %EXIT_CODES = (
    'Need more args'    => 110,
    'Host unreachable'  => 104,
    'Bad answer'        => 103,
    'Flag not found'    => 102,
    'OK'                => 101
);

#===  FUNCTION  ===============================================================
#         NAME: _check
#      PURPOSE: Checking service
#   PARAMETERS: hostname
#      RETURNS: Exit code
#  DESCRIPTION: Check service
#       THROWS: ---
#     COMMENTS: ---
#     SEE ALSO: ---
#==============================================================================
sub _check {
    my $hostname = shift or return $EXIT_CODES{'Need more args'};
    if (system("ping -c 1 -t 3 $hostname > /dev/null 2>&1")) {
        return $EXIT_CODES{'Host unreachable'};
    }
    return $EXIT_CODES{'OK'};
}

#===  FUNCTION  ===============================================================
#         NAME: _put
#      PURPOSE: Putting flag
#   PARAMETERS: hostname, ccn, username, password, address, review
#      RETURNS: Exit code
#  DESCRIPTION: Put action
#       THROWS: ---
#     COMMENTS: ---
#     SEE ALSO: ---
#==============================================================================
sub _put {
    my $hostname    = shift or return $EXIT_CODES{'Need more args'};
    my $ccn         = shift or return $EXIT_CODES{'Need more args'};
    my $username    = shift or return $EXIT_CODES{'Need more args'};
    my $password    = shift or return $EXIT_CODES{'Need more args'};
    my $address     = shift or return $EXIT_CODES{'Need more args'};
    my $review      = shift or return $EXIT_CODES{'Need more args'};
    my $ua          = LWP::UserAgent->new();
    my $page        = $ua->post("http://$hostname:9999/signup", {
        'username'  => $username,
        'address'   => $address,
        'ccn'       => $ccn,
        'review'    => $review,
        'password'  => $password
    });
    my $content     = $page->decoded_content();
    if (0+($content =~ m/User $username was registered/g)) {
        return $EXIT_CODES{'OK'};
    } else {
        return $EXIT_CODES{'Bad answer'};
    }
}

#===  FUNCTION  ===============================================================
#         NAME: _get
#      PURPOSE: Getting flags
#   PARAMETERS: hostname, ccn, username, password
#      RETURNS: Exit code
#  DESCRIPTION: Get flag
#       THROWS: ---
#     COMMENTS: ---
#     SEE ALSO: ---
#==============================================================================
sub _get {
    my $hostname    = shift or return $EXIT_CODES{'Need more args'};
    my $ccn         = shift or return $EXIT_CODES{'Need more args'};
    my $username    = shift or return $EXIT_CODES{'Need more args'};
    my $password    = shift or return $EXIT_CODES{'Need more args'};
    my $ua          = LWP::UserAgent->new();
    $ua->cookie_jar({});
    my $page        = $ua->post("http://$hostname:9999/login", {
        'username'  => $username,
        'password'  => $password
    });
    my %cookie      = %{($ua->cookie_jar())};
    $page           = $ua->get(
        "http://$hostname:9999/profile?username=$username"
    );
    my $content     = $page->decoded_content();
    $content        =~ s/.*<table class="table">[^<]*(.*)[^<]*<\/table.*/$1/s;
    $content        =~ s/[^<\w]*<[^>]+>//g;
    $content        =~ s/\n\s+/\n/g;
    $content        =~ s/^\s*//g;
    $content        =~ s/^([^\n]*\n){3}([^\n]*)\n.*/$2/s;
    if (0+($content =~ m/$ccn/g)) {
        return $EXIT_CODES{'OK'};
    } else {
        return $EXIT_CODES{'Flag not found'};
    }
}

#===  FUNCTION  ===============================================================
#         NAME: main
#      PURPOSE: Choosing action
#   PARAMETERS: hostname, ccn, username, password, address, review
#      RETURNS: Exit code
#  DESCRIPTION: Choose action
#       THROWS: ---
#     COMMENTS: ---
#     SEE ALSO: ---
#==============================================================================
sub main {
    my $cmd         = shift or return $EXIT_CODES{'Need more args'};
    my $hostname    = shift or return $EXIT_CODES{'Need more args'};
    my $ccn;
    my $username;
    my $password;
    my $address;
    my $review;
    if ($cmd eq 'put' or $cmd eq 'get') {
        $ccn        = shift or return $EXIT_CODES{'Need more args'};
        $username   = shift or return $EXIT_CODES{'Need more args'};
        $password   = shift or return $EXIT_CODES{'Need more args'};
    }
    if ($cmd eq 'put') {
        $address    = shift or return $EXIT_CODES{'Need more args'};
        $review     = shift or return $EXIT_CODES{'Need more args'};
    }

    if ($cmd eq 'check') {
        return _check($hostname);
    } elsif ($cmd eq 'put') {
        return _put($hostname, $ccn, $username, $password, $address, $review);
    } elsif ($cmd eq 'get') {
        return _get($hostname, $ccn, $username, $password);
    } else {
        return $EXIT_CODES{'Need more args'};
    }
}

exit main(@ARGV) unless caller;
