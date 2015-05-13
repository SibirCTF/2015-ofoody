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
my %FILES       = (
    'MAIN_PAGE'     => 'index.html',
    'ERROR_PAGE'    => 'error.html',
    'SIGNUP_PAGE'   => 'signup.html',
    'LOGIN_PAGE'    => 'login.html',
    'RESTORE_PAGE'  => 'restore.html',
    'PASSWD_PAGE'   => 'passwd.html',
    'PROFILE_PAGE'  => 'profile.html',
    'REVIEWS_PAGE'  => 'reviews.html'
);

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
    close (INFILE);
    return $content;
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
	return _read_file($HTML_DIR . $FILES{'MAIN_PAGE'});
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
	return _read_file($HTML_DIR . $FILES{'ERROR_PAGE'});
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
	return _read_file($HTML_DIR . $FILES{'SIGNUP_PAGE'});
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
	return _read_file($HTML_DIR . $FILES{'LOGIN_PAGE'});
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
	return _read_file($HTML_DIR . $FILES{'RESTORE_PAGE'});
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
	return _read_file($HTML_DIR . $FILES{'PASSWD_PAGE'});
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
	return _read_file($HTML_DIR . $FILES{'PROFILE_PAGE'});
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
	return _read_file($HTML_DIR . $FILES{'REVIEWS_PAGE'});
}


1;
