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

#===  FUNCTION  ===============================================================
#         NAME: app
#      PURPOSE: O'Foody web service enter point
#   PARAMETERS: ---
#      RETURNS: [status, [headers], [content]]
#  DESCRIPTION: Main PSGI application
#       THROWS: no exceptions
#     COMMENTS: ---
#     SEE ALSO: ---
#==============================================================================
my $app = sub {
    my $env = shift;
    return [200, ['Content-Type' => 'text/plain'], ["hello, everyone\n"]];
};
