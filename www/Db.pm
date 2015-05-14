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
eval "use DBI; 1;"      or $LEGACY = 1;
eval "use DBD::Pg; 1;"  or $LEGACY = 1;

my %POSTGRES_SETTINGS = (
    USER     => 'postgres',
    PASSWORD => '',
    HOST     => '127.0.0.1',
    PORT     => '5432',
    DB       => 'ofoody'
);
my $PSQL_CMD = 'psql\
    --username={USER}\
    --host={HOST}\
    --port={PORT}\
    --dbname={DB}\
    --command="{CMD}"\
';
my $DBI_CMD = 'DBI:Pg:dbname={DB};host={HOST};port={PORT}';

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
    my %content;
    my $string      = shift;
    my $raw_content = shift;
    %content        = %$raw_content if $raw_content;
    foreach my $key (keys %content) {
        $string =~ s/\{$key\}/$content{$key}/;
    }
    return $string;
}

#===  FUNCTION  ===============================================================
#         NAME: create
#      PURPOSE: Creating table
#   PARAMETERS: Table name, [Fields]
#      RETURNS: Integer
#  DESCRIPTION: Create table if not exist
#       THROWS: ---
#     COMMENTS: ---
#     SEE ALSO: ---
#==============================================================================
sub create {
    my $table_name = shift or return 1;
    my @fields = @{(shift)} or return 1;
    my $fields_string = '';
    foreach my $item (@fields) {
        $fields_string .= "@$item[0] @$item[1], ";
    }
    chop($fields_string);
    chop($fields_string);
    my $cmd_string = "CREATE TABLE IF NOT EXISTS $table_name($fields_string);";
    my %POSTGRES = (
        %POSTGRES_SETTINGS,
        'CMD' => $cmd_string
    );
    if ($LEGACY) {
        $cmd_string = _format($PSQL_CMD, \%POSTGRES);
        my $cmd = `$cmd_string`;
    } else {
        my $connection = DBI->connect(
            _format($DBI_CMD, \%POSTGRES),
            $POSTGRES_SETTINGS{'USER'},
            $POSTGRES_SETTINGS{'PASSWORD'}
        );
        $connection->do($cmd_string);
        $connection->disconnect();
    }
    return 0;
}

#===  FUNCTION  ===============================================================
#         NAME: insert
#      PURPOSE: Adding records
#   PARAMETERS: Table name, [Values]
#      RETURNS: Integer
#  DESCRIPTION: Insert values into table
#       THROWS: ---
#     COMMENTS: ---
#     SEE ALSO: ---
#==============================================================================
sub insert {
    my $table_name = shift or return 1;
    my @values = @{(shift)} or return 1;
    my $values_string = '';
    foreach my $item (@values) {
        $values_string .= ", '$item'";
    }
    my $cmd_string = "INSERT INTO $table_name VALUES (DEFAULT$values_string);";
    my %POSTGRES = (
        %POSTGRES_SETTINGS,
        'CMD' => $cmd_string
    );
    if ($LEGACY) {
        $cmd_string = _format($PSQL_CMD, \%POSTGRES);
        my $cmd = `$cmd_string`;
    } else {
        my $connection = DBI->connect(
            _format($DBI_CMD, \%POSTGRES),
            $POSTGRES_SETTINGS{'USER'},
            $POSTGRES_SETTINGS{'PASSWORD'}
        );
        $connection->do($cmd_string);
        $connection->disconnect();
    }
    return 0;
}

1;
