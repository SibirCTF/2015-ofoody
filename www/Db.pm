#!/usr/bin/env perl
#==============================================================================
#
#         FILE: Db.pm
#
#        USAGE: See comments below
#
#  DESCRIPTION: O'Foody Database access module
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

package Db;

use strict;
use warnings FATAL => 'all';
use utf8;

my $LEGACY = 0;
eval "use DBI; 1;" or $LEGACY = 1;

1;
