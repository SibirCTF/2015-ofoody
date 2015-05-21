#!/usr/bin/env perl
#==============================================================================
#
#         FILE: check.pl
#
#        USAGE: ./check.pl IP port username password ccn
#
#  DESCRIPTION: O'Foody service checker
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Vladislav A. Retivykh (var), firolunis@riseup.net
# ORGANIZATION: keva
#      VERSION: 0.1
#      CREATED: 05/21/2015 08:44:35 AM
#     REVISION: ---
#==============================================================================

use strict;
use warnings FATAL => 'all';
use utf8;

use LWP::UserAgent;

my $USAGE = "USAGE: ./check.pl IP port username password ccn\n\n";

my $ip          = shift or print $USAGE and die 'Need IP';
my $port        = shift or die 'Need Port';
my $username    = shift or die 'Need username';
my $password    = shift or die 'Need password';
my $ccn         = shift or die 'Need ccn';
my $ua          = LWP::UserAgent->new();
$ua->cookie_jar({});
my $page        = $ua->post("http://$ip:$port/login", {
    'username'  => $username,
    'password'  => $password
});
my %cookie      = %{($ua->cookie_jar())};
$page           = $ua->get("http://$ip:$port/profile?username=$username");
my $content     = $page->decoded_content();
$content        =~ s/.*<table class="table">[^<]*(.*)[^<]*<\/table.*/$1/s;
$content        =~ s/[^<\w]*<[^>]+>//g;
$content        =~ s/\n\s+/\n/g;
$content        =~ s/^\s*//g;
$content        =~ s/^([^\n]*\n){3}([^\n]*)\n.*/$2/s;
print 0+($content =~ m/$ccn/g);
