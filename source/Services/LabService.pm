#!/usr/bin/perl

package Services::LabService;

use v5.14;
use warnings;

our @EXPORT = qw( get_all_labs get_lab_details );

use DBI;
use Util::Logger;
use constant LOG => 'Util::Logger';

my $db_file = '../db/lab_viewer.db';
my $datasource_name = "dbi:SQLite:dbname=$db_file";
my ( $user, $password ) = '';

my $queries = {
	all_labs => 'SELECT * FROM labs',
	lab_details => 'SELECT * FROM labs WHERE id = ?',
};



die "error: $db_file does not exist!" unless -e $db_file;

my $db_handle = DBI->connect($datasource_name, $user, $password, {
	PrintError => 0,
	RaiseError       => 1,
	AutoCommit       => 1,
	FetchHashKeyName => 'NAME_lc',
});

sub get_all_labs{
	my $stmt_handle = $db_handle->prepare($$queries{all_labs});
	LOG->write_msg('get_all_labs called');
	$stmt_handle->execute;
	$stmt_handle->fetchall_arrayref({});
}

sub get_lab_details {
	my $stmt_handle = $db_handle->prepare($$queries{lab_details});
	LOG->write_msg('get_lab_details called');
	$stmt_handle->bind_param(1, $_[-1]);
	$stmt_handle->execute;
	$stmt_handle->fetchrow_hashref();
}

1;
