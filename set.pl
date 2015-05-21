#!/usr/bin/env perl
#==============================================================================
#
#         FILE: set.pl
#
#        USAGE: ./set.pl IP port username address ccn review password
#
#  DESCRIPTION: O'Foody service flag setter
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Vladislav A. Retivykh (var), firolunis@riseup.net
# ORGANIZATION: keva
#      VERSION: 0.1
#      CREATED: 05/21/2015 08:44:23 AM
#     REVISION: ---
#==============================================================================

use strict;
use warnings FATAL => 'all';
use utf8;

use LWP::UserAgent;

my $USAGE = "USAGE: ./set.pl IP port username address ccn review password\n\n";

my $ip          = shift or print $USAGE and die 'Need IP';
my $port        = shift or die 'Need Port';
my $username    = shift or die 'Need username';
my $address     = shift or die 'Need address';
my $ccn         = shift or die 'Need ccn';
my $review      = shift or die 'Need review';
my $password    = shift or die 'Need password';
my $ua          = LWP::UserAgent->new();
my $page        = $ua->post("http://$ip:$port/signup", {
    'username'  => $username,
    'address'   => $address,
    'ccn'       => $ccn,
    'review'    => $review,
    'password'  => $password
});
my $content     = $page->decoded_content();
print 0+($content =~ m/User $username was registered/g);
