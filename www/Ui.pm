#!/usr/bin/env perl
#==============================================================================
#
#         FILE: Ui.pm
#
#        USAGE: See comments below
#
#  DESCRIPTION: O'Foody Web UI module
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Vladislav A. Retivykh (var), firolunis@riseup.net
# ORGANIZATION: keva
#      VERSION: 0.1
#      CREATED: 05/13/2015 11:35:18 AM
#     REVISION: ---
#==============================================================================

package Ui;

use strict;
use warnings FATAL => 'all';
use utf8;

my $HTML_DIR    = 'static/';
my %PAGES       = (
    'MAIN_PAGE'     => [
        'index.html',
        'Cookie in the jar',
        'Whiskey and cookies delivery'
    ],
    'ERROR_PAGE'    => [
        'error.html',
        'Error',
        'Something went wrong'
    ],
    'SIGNUP_PAGE'   => [
        'signup.html',
        'Sign Up',
        'Registration'
    ],
    'LOGIN_PAGE'    => [
        'login.html',
        'Log In',
        'Log In'
    ],
    'RESTORE_PAGE'  => [
        'restore.html',
        'Restore password',
        'Restore password'
    ],
    'PASSWD_PAGE'   => [
        'passwd.html',
        'Change password',
        'Change password'
    ],
    'PROFILE_PAGE'  => [
        'profile.html',
        'View profile',
        'Profile'
    ],
    'REVIEWS_PAGE'  => [
        'reviews.html',
        'Read users reviews',
        'Reviews'
    ],
    'HEADER'        => [
        'header.html'
    ],
    'HEADER_USER'   => [
        'header_user.html'
    ],
    'FOOTER'        => [
        'footer.html'
    ]
);

#===  FUNCTION  ===============================================================
#         NAME: _read_file
#      PURPOSE: Reading HTML PAGES 
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
    close (INFILE);
    return $content;
}

#===  FUNCTION  ===============================================================
#         NAME: _format
#      PURPOSE: Formatting strings
#   PARAMETERS: String, {Content}
#      RETURNS: Formatted string
#  DESCRIPTION: Fill string with hash values
#       THROWS: ---
#     COMMENTS: ---
#     SEE ALSO: ---
#==============================================================================
sub _format {
    my $string      = shift;
    my $raw_content = shift;
    my %content     = %$raw_content if $raw_content;
    foreach my $key (keys %content) {
        $string =~ s/\{$key\}/$content{$key}/;
    }
    return $string;
}

#===  FUNCTION  ===============================================================
#         NAME: main_page
#      PURPOSE: Generating main page
#   PARAMETERS: ---
#      RETURNS: Main page HTML code
#  DESCRIPTION: Generate main page HTML code
#       THROWS: ---
#     COMMENTS: ---
#     SEE ALSO: ---
#==============================================================================
sub main_page {
    my $raw_content = shift;
    my %content     = %$raw_content if $raw_content;
    %content        = (
        %content,
        'title' => $PAGES{'MAIN_PAGE'}[1],
        'head'  => $PAGES{'MAIN_PAGE'}[2]
    );
    my $page;
    if (exists $content{'name'}) {
        $page = _read_file($HTML_DIR . $PAGES{'HEADER_USER'}[0]);
    } else {
        $page = _read_file($HTML_DIR . $PAGES{'HEADER'}[0]);
    }
    $page   .=  _read_file($HTML_DIR . $PAGES{'MAIN_PAGE'}[0]);
    $page   .=  _read_file($HTML_DIR . $PAGES{'FOOTER'}[0]);
    $page   =   _format($page, \%content);
    return $page;
}

#===  FUNCTION  ===============================================================
#         NAME: error_page
#      PURPOSE: Generating error page
#   PARAMETERS: ---
#      RETURNS: Error page HTML code
#  DESCRIPTION: Generate error page HTML code
#       THROWS: ---
#     COMMENTS: ---
#     SEE ALSO: ---
#==============================================================================
sub error_page {
    my $raw_content = shift;
    my %content     = %$raw_content if $raw_content;
    %content        = (
        %content,
        'title' => $PAGES{'ERROR_PAGE'}[1],
        'head'  => $PAGES{'ERROR_PAGE'}[2]
    );
    if (!exists $content{'msg'}) {
        $content{'msg'} = '';
    }
    my $page;
    if (exists $content{'name'}) {
        $page = _read_file($HTML_DIR . $PAGES{'HEADER_USER'}[0]);
    } else {
        $page = _read_file($HTML_DIR . $PAGES{'HEADER'}[0]);
    }
    $page   .=  _read_file($HTML_DIR . $PAGES{'ERROR_PAGE'}[0]);
    $page   .=  _read_file($HTML_DIR . $PAGES{'FOOTER'}[0]);
    $page   =   _format($page, \%content);
    return $page;
}

#===  FUNCTION  ===============================================================
#         NAME: signup_page
#      PURPOSE: Generating sign up page
#   PARAMETERS: ---
#      RETURNS: Sign up page HTML code
#  DESCRIPTION: Generate sign up page HTML code
#       THROWS: ---
#     COMMENTS: ---
#     SEE ALSO: ---
#==============================================================================
sub signup_page {
    my $raw_content = shift;
    my %content     = %$raw_content if $raw_content;
    %content        = (
        %content,
        'title' => $PAGES{'SIGNUP_PAGE'}[1],
        'head'  => $PAGES{'SIGNUP_PAGE'}[2]
    );
    if (!exists $content{'msg'}) {
        $content{'msg'} = '';
    }
    my $page;
    $page   =   _read_file($HTML_DIR . $PAGES{'HEADER'}[0]);
    $page   .=  _read_file($HTML_DIR . $PAGES{'SIGNUP_PAGE'}[0]);
    $page   .=  _read_file($HTML_DIR . $PAGES{'FOOTER'}[0]);
    $page   =   _format($page, \%content);
    return $page;
}

#===  FUNCTION  ===============================================================
#         NAME: login_page
#      PURPOSE: Generating log in page
#   PARAMETERS: ---
#      RETURNS: Log in page HTML code
#  DESCRIPTION: Generate log in page HTML code
#       THROWS: ---
#     COMMENTS: ---
#     SEE ALSO: ---
#==============================================================================
sub login_page {
    my $raw_content = shift;
    my %content     = %$raw_content if $raw_content;
    %content        = (
        %content,
        'title' => $PAGES{'LOGIN_PAGE'}[1],
        'head'  => $PAGES{'LOGIN_PAGE'}[2]
    );
    if (!exists $content{'msg'}) {
        $content{'msg'} = '';
    }
    my $page;
    $page   =   _read_file($HTML_DIR . $PAGES{'HEADER'}[0]);
    $page   .=  _read_file($HTML_DIR . $PAGES{'LOGIN_PAGE'}[0]);
    $page   .=  _read_file($HTML_DIR . $PAGES{'FOOTER'}[0]);
    $page   =   _format($page, \%content);
    return $page;
}

#===  FUNCTION  ===============================================================
#         NAME: restore_page
#      PURPOSE: Generating restore password page
#   PARAMETERS: ---
#      RETURNS: Restore password page HTML code
#  DESCRIPTION: Generate restore password page HTML code
#       THROWS: ---
#     COMMENTS: ---
#     SEE ALSO: ---
#==============================================================================
sub restore_page {
    my $raw_content = shift;
    my %content     = %$raw_content if $raw_content;
    %content        = (
        %content,
        'title' => $PAGES{'RESTORE_PAGE'}[1],
        'head'  => $PAGES{'RESTORE_PAGE'}[2]
    );
    if (!exists $content{'msg'}) {
        $content{'msg'} = '';
    }
    my $page;
    $page   =   _read_file($HTML_DIR . $PAGES{'HEADER'}[0]);
    $page   .=  _read_file($HTML_DIR . $PAGES{'RESTORE_PAGE'}[0]);
    $page   .=  _read_file($HTML_DIR . $PAGES{'FOOTER'}[0]);
    $page   =   _format($page, \%content);
    return $page;
}

#===  FUNCTION  ===============================================================
#         NAME: passwd_page
#      PURPOSE: Generating change password page
#   PARAMETERS: ---
#      RETURNS: Change password page HTML code
#  DESCRIPTION: Generate change password page HTML code
#       THROWS: ---
#     COMMENTS: ---
#     SEE ALSO: ---
#==============================================================================
sub passwd_page {
    my $raw_content = shift;
    my %content     = %$raw_content if $raw_content;
    %content        = (
        %content,
        'title' => $PAGES{'PASSWD_PAGE'}[1],
        'head'  => $PAGES{'PASSWD_PAGE'}[2]
    );
    if (!exists $content{'msg'}) {
        $content{'msg'} = '';
    }
    my $page;
    $page   =   _read_file($HTML_DIR . $PAGES{'HEADER_USER'}[0]);
    $page   .=  _read_file($HTML_DIR . $PAGES{'PASSWD_PAGE'}[0]);
    $page   .=  _read_file($HTML_DIR . $PAGES{'FOOTER'}[0]);
    $page   =   _format($page, \%content);
    return $page;
}

#===  FUNCTION  ===============================================================
#         NAME: profile_page
#      PURPOSE: Generating profile page
#   PARAMETERS: ---
#      RETURNS: Profile page HTML code
#  DESCRIPTION: Generate profile page HTML code
#       THROWS: ---
#     COMMENTS: ---
#     SEE ALSO: ---
#==============================================================================
sub profile_page {
    my $raw_content = shift;
    my %content     = %$raw_content if $raw_content;
    %content        = (
        %content,
        'title' => $PAGES{'PROFILE_PAGE'}[1],
        'head'  => $PAGES{'PROFILE_PAGE'}[2]
    );
    if (!exists $content{'msg'}) {
        $content{'msg'} = '';
    }
    my $page;
    if (exists $content{'name'}) {
        $page = _read_file($HTML_DIR . $PAGES{'HEADER_USER'}[0]);
    } else {
        $page = _read_file($HTML_DIR . $PAGES{'HEADER'}[0]);
    }
    $page   .=  _read_file($HTML_DIR . $PAGES{'PROFILE_PAGE'}[0]);
    $page   .=  _read_file($HTML_DIR . $PAGES{'FOOTER'}[0]);
    $page   =   _format($page, \%content);
    return $page;
}

#===  FUNCTION  ===============================================================
#         NAME: reviews_page
#      PURPOSE: Generating reviews page
#   PARAMETERS: ---
#      RETURNS: Reviews page HTML code
#  DESCRIPTION: Generate reviews page HTML code
#       THROWS: ---
#     COMMENTS: ---
#     SEE ALSO: ---
#==============================================================================
sub reviews_page {
    my $raw_content = shift;
    my %content     = %$raw_content if $raw_content;
    %content        = (
        %content,
        'title' => $PAGES{'REVIEWS_PAGE'}[1],
        'head'  => $PAGES{'REVIEWS_PAGE'}[2]
    );
    if (!exists $content{'msg'}) {
        $content{'msg'} = '';
    }
    my $page;
    if (exists $content{'name'}) {
        $page = _read_file($HTML_DIR . $PAGES{'HEADER_USER'}[0]);
    } else {
        $page = _read_file($HTML_DIR . $PAGES{'HEADER'}[0]);
    }
    $page   .=  _read_file($HTML_DIR . $PAGES{'REVIEWS_PAGE'}[0]);
    $page   .=  _read_file($HTML_DIR . $PAGES{'FOOTER'}[0]);
    $page   =   _format($page, \%content);
    return $page;
}


1;
