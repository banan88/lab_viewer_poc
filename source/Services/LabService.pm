#!/usr/bin/perl

package Services::LabService;

use v5.14;
use warnings;

our @EXPORT = qw( get_all_labs get_lab_details create_lab );

use DBI;

my $db_file = '../db/lab_viewer.db';
my $datasource_name = "dbi:SQLite:dbname=$db_file";
my ( $user, $password ) = '';

my $queries = {
	all_labs => 'SELECT * FROM labs',
	lab_details => 'SELECT * FROM labs WHERE id = ?',
	create_lab => 'INSERT INTO labs VALUES(null, ?, ?)',
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
	$stmt_handle->execute;
	$stmt_handle->fetchall_arrayref({});
}

sub get_lab_details {
	my ($self, $lab_id) = @_;
	my $stmt_handle = $db_handle->prepare($$queries{lab_details});
	$stmt_handle->bind_param(1, $lab_id);
	$stmt_handle->execute;
	$stmt_handle->fetchrow_hashref();
}

sub create_lab {
	my ($self, $lab_name, $lab_desc) = @_;
	say $lab_name;
	say $lab_desc;
	say "CREATING!";
	my $stmt_handle = $db_handle->prepare($$queries{create_lab});
	$stmt_handle->bind_param(1, $lab_name);
	$stmt_handle->bind_param(2, $lab_desc);
	$stmt_handle->execute;
	$stmt_handle = $db_handle->prepare('SELECT last_insert_rowid() AS rowid FROM labs LIMIT 1');
	$stmt_handle->execute;
	say $stmt_handle->fetchall_arrayref({});
}

1;
