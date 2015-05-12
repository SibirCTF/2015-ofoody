#!/usr/bin/env perl
#==============================================================================
#
#         FILE: ofoody.pl
#
#        USAGE: See PSGI documentation
#
#  DESCRIPTION: O'Foody web service
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Vladislav A. Retivykh (var), firolunis@riseup.net
# ORGANIZATION: keva
#      VERSION: 0.1
#      CREATED: 05/12/2015 09:31:17 AM
#     REVISION: ---
#==============================================================================

use strict;
use warnings FATAL => 'all';
use utf8;

use Data::Dumper;
use Switch;

my $HTML_DIR = 'static/';
my %FILES = (
    'MAIN_PAGE' => 'index.html',
    'ERROR_PAGE' => 'error.html',
    'SIGNUP_PAGE' => 'signup.html',
    'LOGIN_PAGE' => 'login.html',
    'RESTORE_PAGE' => 'restore.html',
    'PASSWD_PAGE' => 'passwd.html',
    'PROFILE_PAGE' => 'profile.html',
    'REVIEWS_PAGE' => 'reviews.html'
);
#===  FUNCTION  ===============================================================
#         NAME: _get_cookies
#      PURPOSE: Extracting cookies
#   PARAMETERS: Environment dictionary
#      RETURNS: {Cookies}
#  DESCRIPTION: Extract and parse cookie from environment dictionary
#       THROWS: ---
#     COMMENTS: ---
#     SEE ALSO: ---
#==============================================================================
sub _get_cookies {
    my $env = shift;
    my $raw_cookies = '';
    $raw_cookies = $env->{'HTTP_COOKIE'} if exists $env->{'HTTP_COOKIE'};
    my @baked_cookies = split /; /, $raw_cookies;
    my %cookies;
    foreach my $item (@baked_cookies) {
        my ($i, $j) = split /=/, $item;
        $cookies{$i} = $j;
    }
    return %cookies;
}
#===  FUNCTION  ===============================================================
#         NAME: _get_post_data
#      PURPOSE: Extracting POST data
#   PARAMETERS: Environment dictionary
#      RETURNS: {POST data}
#  DESCRIPTION: Extract and parse POST data from environment dictionary
#       THROWS: ---
#     COMMENTS: ---
#     SEE ALSO: ---
#==============================================================================
sub _get_post_data {
    my $env = shift;
    my $content_length = $env->{'CONTENT_LENGTH'};
    my $raw_post_data;
    $env->{'psgi.input'}->read($raw_post_data, $content_length);
    my @prepared_post_data = split /&/, $raw_post_data;
    my %post_data;
    foreach my $item (@prepared_post_data) {
        my ($i, $j) = split /=/, $item;
        $post_data{$i} = $j;
    }
    return %post_data;
}
#===  FUNCTION  ===============================================================
#         NAME: _get_query_data
#      PURPOSE: Extracting query data
#   PARAMETERS: Environment dictionary
#      RETURNS: {Query data}
#  DESCRIPTION: Extract and parse query data from environment dictionary
#       THROWS: ---
#     COMMENTS: ---
#     SEE ALSO: ---
#==============================================================================
sub _get_query_data {
    my $env = shift;
    my $raw_query_data = $env->{'QUERY_STRING'};
    my @prepared_query_data = split /&/, $raw_query_data;
    my %query_data;
    foreach my $item (@prepared_query_data) {
        my ($i, $j) = split /=/, $item;
        $query_data{$i} = $j;
    }
    return %query_data;
}
#===  FUNCTION  ===============================================================
#         NAME: _get_path
#      PURPOSE: Extracting path 
#   PARAMETERS: Environment dictionary
#      RETURNS: [Path]
#  DESCRIPTION: Extract and parse path from environment dictionary
#       THROWS: ---
#     COMMENTS: ---
#     SEE ALSO: ---
#==============================================================================
sub _get_path {
    my $env = shift;
    my $raw_path = $env->{'PATH_INFO'};
    my @path = split /\//, $raw_path;
    shift @path;
    push @path, '' if not @path;
    return @path;
}
#===  FUNCTION  ===============================================================
#         NAME: _read_file
#      PURPOSE: Reading HTML files 
#   PARAMETERS: Path to file
#      RETURNS: File content
#  DESCRIPTION: Read file to string
#       THROWS: ---
#     COMMENTS: ---
#     SEE ALSO: ---
#==============================================================================
sub _read_file {
    local $/;
    my $path_to_file = shift;
    open(INFILE, $path_to_file) or die "Can't read file $path_to_file [$!]\n";  
    my $content = <INFILE>; 
    close (FILE);  
    return $content;
}
#===  FUNCTION  ===============================================================
#         NAME: choose_action
#      PURPOSE: Handle request
#   PARAMETERS: Environment dictionary
#      RETURNS: [Status, [Headers], [Content]]
#  DESCRIPTION: Main application's logic
#       THROWS: ---
#     COMMENTS: ---
#     SEE ALSO: ---
#==============================================================================
sub choose_action {
    my $env = shift;
    my $env_str = Dumper($env);
    my @query_data = _get_path($env);
    my $response;
    switch ($query_data[0]) {
        case '' {
            $response = _read_file($HTML_DIR . $FILES{'MAIN_PAGE'});
            # $response = _read_file('static/' . 'index.html');
        }
        case 'login' {
            $response = _read_file($HTML_DIR . $FILES{'LOGIN_PAGE'});
        }
        case 'signup' {
            $response = _read_file($HTML_DIR . $FILES{'SIGNUP_PAGE'});
        }
        case 'passwd' {
            $response = _read_file($HTML_DIR . $FILES{'PASSWD_PAGE'});
        }
        case 'restore' {
            $response = _read_file($HTML_DIR . $FILES{'RESTORE_PAGE'});
        }
        case 'reviews' {
            $response = _read_file($HTML_DIR . $FILES{'REVIEWS_PAGE'});
        }
        case 'profile' {
            $response = _read_file($HTML_DIR . $FILES{'PROFILE_PAGE'});
        }
        else {
            $response = _read_file($HTML_DIR . $FILES{'ERROR_PAGE'});
        }
    }
    return [200, ['Content-Type' => 'text/html'], ["$response\n"]];
}
#===  FUNCTION  ===============================================================
#         NAME: app
#      PURPOSE: O'Foody web service enter point
#   PARAMETERS: ---
#      RETURNS: [Status, [Headers], [Content]]
#  DESCRIPTION: Main PSGI application
#       THROWS: ---
#     COMMENTS: ---
#     SEE ALSO: ---
#==============================================================================
my $app = sub {
    my $env = shift;
    return &choose_action($env);
};
