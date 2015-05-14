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

use Switch;

use Data::Dumper;

use Ui;
use Db;

#===  FUNCTION  ===============================================================
#         NAME: _get_cookie
#      PURPOSE: Extracting cookie
#   PARAMETERS: Environment dictionary
#      RETURNS: {Cookie}
#  DESCRIPTION: Extract and parse cookie from environment dictionary
#       THROWS: ---
#     COMMENTS: ---
#     SEE ALSO: ---
#==============================================================================
sub _get_cookie {
    my $raw_env     = shift;
    my %env         = %$raw_env;
    my $raw_cookie  = '';
    $raw_cookie     = $env{'HTTP_COOKIE'} if exists $env{'HTTP_COOKIE'};
    my @baked_cookie    = split /; /, $raw_cookie;
    my %cookie;
    foreach my $item (@baked_cookie) {
        my ($i, $j) = split /=/, $item;
        $cookie{$i} = $j;
    }
    return %cookie;
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
    my $raw_env         = shift;
    my %env             = %$raw_env;
    my $content_length  = 0;
    $content_length     = $env{'CONTENT_LENGTH'} if $env{'CONTENT_LENGTH'};
    my $raw_post_data;
    $env{'psgi.input'}->read($raw_post_data, $content_length);
    my @prepared_post_data = split /&/, $raw_post_data;
    my %post_data;
    foreach my $item (@prepared_post_data) {
        my ($i, $j)     = split /=/, $item;
        $post_data{$i}  = $j;
        $post_data{$i}  =~ tr/+/ /;
        $post_data{$i}  =~ s/%([\da-f][\da-f])/chr( hex($1) )/egi;
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
    my $raw_env             = shift;
    my %env                 = %$raw_env;
    my $raw_query_data      = $env{'QUERY_STRING'};
    my @prepared_query_data = split /&/, $raw_query_data;
    my %query_data;
    foreach my $item (@prepared_query_data) {
        my ($i, $j)     = split /=/, $item;
        $query_data{$i} = $j;
        $query_data{$i} =~ tr/+/ /;
        $query_data{$i} =~ s/%([\da-f][\da-f])/chr( hex($1) )/egi;
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
    my $raw_env     = shift;
    my %env         = %$raw_env;
    my $raw_path    = $env{'PATH_INFO'};
    my @path        = split /\//, $raw_path;
    shift @path;
    push @path, '' if not @path;
    return @path;
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
    my $raw_env = shift;
    my %env     = %$raw_env;
    my @path    = _get_path(\%env);
    my $response;
    switch ($path[0]) {
        case '' {
            $response = Ui::main_page();
        }
        case 'login' {
            my %content;
            $content{'msg'} = Dumper(_get_post_data(\%env));
            $response = Ui::login_page(\%content);
        }
        case 'signup' {
            my %content;
            my %post_data = _get_post_data(\%env);
            if (%post_data) {
                my @values = (
                    $post_data{'username'},
                    $post_data{'review'},
                    $post_data{'ccn'},
                    $post_data{'address'},
                    $post_data{'password'}
                );
                Db::insert('USERS', \@values);
                $content{'msg'} = 'OK';
            }
            $response = Ui::signup_page(\%content);
        }
        case 'passwd' {
            $response = Ui::passwd_page();
        }
        case 'restore' {
            $response = Ui::restore_page();
        }
        case 'reviews' {
            $response = Ui::reviews_page();
        }
        case 'profile' {
            $response = Ui::profile_page();
        }
        else {
            my %content = (
                'msg' => 'File not found'
            );
            $response = Ui::error_page(\%content);
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
    return &choose_action(\%$env);
};
