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

use Auth;
use Ui;

my %TABLES = (
    'USERS' => 'USERS'
);

#===  FUNCTION  ===============================================================
#         NAME: _get_cookie
#      PURPOSE: Extracting cookie
#   PARAMETERS: {Environment}
#      RETURNS: {Cookie}
#  DESCRIPTION: Extract and parse cookie from environment dictionary
#       THROWS: ---
#     COMMENTS: ---
#     SEE ALSO: ---
#==============================================================================
sub _get_cookie {
    my %env         = %{(shift)} or return 0;
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
#   PARAMETERS: {Environment}
#      RETURNS: {POST data}
#  DESCRIPTION: Extract and parse POST data from environment dictionary
#       THROWS: ---
#     COMMENTS: ---
#     SEE ALSO: ---
#==============================================================================
sub _get_post_data {
    my %env             = %{(shift)} or return 0;
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
#   PARAMETERS: {Environment}
#      RETURNS: {Query data}
#  DESCRIPTION: Extract and parse query data from environment dictionary
#       THROWS: ---
#     COMMENTS: ---
#     SEE ALSO: ---
#==============================================================================
sub _get_query_data {
    my %env                 = %{(shift)} or return 0;
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
#   PARAMETERS: {Environment}
#      RETURNS: [Path]
#  DESCRIPTION: Extract and parse path from environment dictionary
#       THROWS: ---
#     COMMENTS: ---
#     SEE ALSO: ---
#==============================================================================
sub _get_path {
    my %env         = %{(shift)} or return 0;
    my $raw_path    = $env{'PATH_INFO'};
    my @path        = split /\//, $raw_path;
    shift @path;
    push @path, '' if not @path;
    return @path;
}

#===  FUNCTION  ===============================================================
#         NAME: main
#      PURPOSE: Handling empty request
#   PARAMETERS: {Cookie}
#      RETURNS: Page, [Headers]
#  DESCRIPTION: Handle empty request
#       THROWS: ---
#     COMMENTS: ---
#     SEE ALSO: ---
#==============================================================================
sub main {
    my %cookie = %{(shift)};
    my %content;
    my @headers;
    if (exists $cookie{'username'}) {
        %content = (
            %content,
            'username'      => $cookie{'username'},
            'username_url'  => $cookie{'username'}
        );
    }
    return (Ui::main_page(\%content), @headers);
}

#===  FUNCTION  ===============================================================
#         NAME: signup
#      PURPOSE: Handling signup request
#   PARAMETERS: {Cookie}, {POST data}
#      RETURNS: Page, [Headers]
#  DESCRIPTION: Handle signup request
#       THROWS: ---
#     COMMENTS: ---
#     SEE ALSO: ---
#==============================================================================
sub signup {
    my %cookie      = %{(shift)};
    my %post_data   = %{(shift)};
    my %content;
    my @headers;
    if (%post_data) {
        $content{'msg'} = Auth::signup(\%post_data);
    }
    return (Ui::signup_page(\%content), @headers);
}

#===  FUNCTION  ===============================================================
#         NAME: login
#      PURPOSE: Handling login request
#   PARAMETERS: {Cookie}, {POST data}
#      RETURNS: Page, [Headers]
#  DESCRIPTION: Handle login request
#       THROWS: ---
#     COMMENTS: ---
#     SEE ALSO: ---
#==============================================================================
sub login {
    my %cookie      = %{(shift)};
    my %post_data   = %{(shift)};
    my %content;
    my @headers;
    my @new_cookie;
    if (%post_data) {
        ($content{'msg'}, @new_cookie) = Auth::login(\%post_data);
    }
    while (@new_cookie) {
        push @headers, ('Set-Cookie', shift @new_cookie);
    }
    return (Ui::login_page(\%content), @headers);
}

#===  FUNCTION  ===============================================================
#         NAME: logout
#      PURPOSE: Handling logout request
#   PARAMETERS: ---
#      RETURNS: Page, [Headers]
#  DESCRIPTION: Handle logout request
#       THROWS: ---
#     COMMENTS: ---
#     SEE ALSO: ---
#==============================================================================
sub logout {
    my @headers;
    my @new_cookie;
    @new_cookie = Auth::logout();
    while (@new_cookie) {
        push @headers, ('Set-Cookie', shift @new_cookie);
    }
    return (Ui::main_page(), @headers);
}

#===  FUNCTION  ===============================================================
#         NAME: restore
#      PURPOSE: Handling restore request
#   PARAMETERS: {Cookie}, {POST data}
#      RETURNS: Page, [Headers]
#  DESCRIPTION: Handle restore request
#       THROWS: ---
#     COMMENTS: ---
#     SEE ALSO: ---
#==============================================================================
sub restore {
    my %cookie      = %{(shift)};
    my %post_data   = %{(shift)};
    my %content;
    my @headers;
    if (%post_data) {
        $content{'msg'} = Auth::restore(\%post_data);
    }
    return (Ui::restore_page(\%content), @headers);
}

#===  FUNCTION  ===============================================================
#         NAME: passwd
#      PURPOSE: Handling passwd request
#   PARAMETERS: {Cookie}, {POST data}
#      RETURNS: Page, [Headers]
#  DESCRIPTION: Handle passwd request
#       THROWS: ---
#     COMMENTS: ---
#     SEE ALSO: ---
#==============================================================================
sub passwd {
    my %cookie      = %{(shift)};
    my %post_data   = %{(shift)};
    my %content;
    my @headers;
    if (exists $cookie{'username'}) {
        if (%post_data) {
            %post_data = (
                %post_data,
                'username' => $cookie{'username'}
            );
            $content{'msg'} = Auth::passwd(\%post_data);
        }
        %content = (
            %content,
            'username'      => $cookie{'username'},
            'username_url'  => $cookie{'username'}
        );
    } else {
        $content{'msg'} = 'You must be logged in';
    }
    return (Ui::passwd_page(\%content), @headers);
}

#===  FUNCTION  ===============================================================
#         NAME: profile
#      PURPOSE: Handling profile request
#   PARAMETERS: {Cookie}, {POST data}, {Query data}
#      RETURNS: Page, [Headers]
#  DESCRIPTION: Handle profile request
#       THROWS: ---
#     COMMENTS: ---
#     SEE ALSO: ---
#==============================================================================
sub profile {
    my %cookie      = %{(shift)};
    my %post_data   = %{(shift)};
    my %query_data  = %{(shift)};
    my %content;
    my @headers;
    if (exists $query_data{'username'}) {
        my @table;
        map push(@table, @$_), Db::select(
            $TABLES{'USERS'},
            {'username' => $query_data{'username'}}
        );
        if (!exists $cookie{'session'} || !Auth::check($query_data{'username'}, $cookie{'session'})) {
            splice @table, 5, 1;
            splice @table, 3, 1;
        }
        foreach my $item (@table) {
            $content{'msg'} .= "<tr>\
                                <td>\
                                    $item\
                                </td>\
                            </tr>\
                            ";
        }
    } else {
        $content{'msg'} = 'Me want username';
    }
    if (exists $cookie{'username'}) {
        %content = (
            %content,
            'username'      => $cookie{'username'},
            'username_url'  => $cookie{'username'}
        );
    }
    return (Ui::profile_page(\%content), @headers);
}

#===  FUNCTION  ===============================================================
#         NAME: reviews
#      PURPOSE: Handling reviews request
#   PARAMETERS: {Cookie}
#      RETURNS: Page, [Headers]
#  DESCRIPTION: Handle reviews request
#       THROWS: ---
#     COMMENTS: ---
#     SEE ALSO: ---
#==============================================================================
sub reviews {
    my %cookie      = %{(shift)};
    my %content;
    my @table = Db::select($TABLES{'USERS'}, {});
    foreach my $item (@table) {
        if (!@$item[2]) {
            map splice(@$_, 2, 1), @table;
        }
        $content{'msg'} .= "<tr>\
                                <td>\
                                    @$item[1]\
                                ";
        $content{'msg'} .= "</td>\
                                <td>\
                                    @$item[2]\
                                ";
        $content{'msg'} .= "</td>\
                            </tr>\
                            ";
    }
    if (exists $cookie{'username'}) {
        %content = (
            %content,
            'username'      => $cookie{'username'},
            'username_url'  => $cookie{'username'}
        );
    }
    return Ui::reviews_page(\%content);
}

#===  FUNCTION  ===============================================================
#         NAME: error
#      PURPOSE: Handling error request
#   PARAMETERS: {Cookie}
#      RETURNS: Page, [Headers]
#  DESCRIPTION: Handle error request
#       THROWS: ---
#     COMMENTS: ---
#     SEE ALSO: ---
#==============================================================================
sub error {
    my %content = (
        'msg' => 'File not found'
    );
    return Ui::error_page(\%content);
}

#===  FUNCTION  ===============================================================
#         NAME: choose_action
#      PURPOSE: Handle request
#   PARAMETERS: Environment dictionary
#      RETURNS: Status, [Headers], [Content]
#  DESCRIPTION: Main application's logic
#       THROWS: ---
#     COMMENTS: ---
#     SEE ALSO: ---
#==============================================================================
sub choose_action {
    my %env         = %{(shift)} or return 0;
    my @path        = _get_path(\%env);
    my %cookie      = _get_cookie(\%env);
    my %post_data   = _get_post_data(\%env);
    my %query_data  = _get_query_data(\%env);
    my $username    = '';
    my $session     = '';
    my %actions     = (
        ''          => \&main,
        'signup'    => \&signup,
        'login'     => \&login,
        'logout'    => \&logout,
        'restore'   => \&restore,
        'passwd'    => \&passwd,
        'profile'   => \&profile,
        'reviews'   => \&reviews,
        'error'     => \&error
    );
    my $response;
    my @headers;

    if (exists $actions{$path[0]}) {
        ($response, @headers) = $actions{$path[0]}(
            \%cookie,
            \%post_data,
            \%query_data
        );
    } else {
        ($response, @headers) = $actions{'error'}(\%cookie);
    }
    push @headers, ('Content-Type', 'text/html');
    return [200, \@headers, [$response]];
}

#===  FUNCTION  ===============================================================
#         NAME: app
#      PURPOSE: O'Foody web service enter point
#   PARAMETERS: ---
#      RETURNS: Status, [Headers], [Content]
#  DESCRIPTION: Main PSGI application
#       THROWS: ---
#     COMMENTS: ---
#     SEE ALSO: ---
#==============================================================================
my $app = sub {
    my $env = shift;
    return &choose_action(\%$env);
};
