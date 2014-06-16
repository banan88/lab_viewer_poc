#!/usr/bin/perl

package Controllers::LabController;

use v5.14;
use warnings;

our @EXPORT = qw( get_all_labs );

use JSON;

my $json_encoder = JSON->new->allow_nonref;


sub get_all_labs {
	return (200, $json_encoder->encode('get_all_labs called!'));
}

sub get_lab_details {
	return (200, $json_encoder->encode('get_lab_details called!'));
}

1;