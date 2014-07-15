#!/usr/bin/perl

package Controllers::LabController;

use v5.14;
use warnings;

our @EXPORT = qw( get_all_labs );

use JSON;
use Services::LabService;

use constant service => 'Services::LabService';


my $json_encoder = JSON->new->allow_nonref;

sub get_all_labs {
	return (200, $json_encoder->encode(service->get_all_labs));
}

sub get_lab_details {
	my $lab = service->get_lab_details($_[-1]);
	$lab ?(400, $json_encoder->encode($lab)) : (200, $json_encoder->encode("lab with id=$_[-1] does not exist."));
}

1;