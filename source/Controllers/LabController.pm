#!/usr/bin/perl

package Controllers::LabController;

use v5.14;
use warnings;

our @EXPORT = qw( single_lab_action all_labs_action );

use JSON;
use Services::LabService;
use Data::Dumper;

use constant service => 'Services::LabService';

my $json_encoder = JSON->new->allow_nonref;

use constant LABS_METHODS => {
	'GET' => \&all_labs_action_GET, 
	'POST' => \&all_labs_action_POST,
};

use constant LAB_METHODS => {
	'GET' => \&single_lab_action_GET, 
};


sub all_labs_action {
	my ($self, $arguments) = @_; 
	my $request = $arguments->{'request'};
	my $action_result = LABS_METHODS->{$request->method};
	$action_result ? ($action_result->(@_)) : (respond_with_method_not_allowed(keys LABS_METHODS)) ;
}

sub single_lab_action {
	my ($self, $arguments) = @_; 
	my $request = $arguments->{'request'};
	my $action_result = LAB_METHODS->{$request->method};
	$action_result ? ($action_result->(@_)) : (respond_with_method_not_allowed(keys LAB_METHODS )) ;
}

sub respond_with_method_not_allowed{
	return (405, 'The only allowed are: '.join(', ', @_ ));
}

sub all_labs_action_GET {
	return (200, $json_encoder->encode(service->get_all_labs));
}

sub all_labs_action_POST {
	my ($self, $arguments) = @_; 
	my $request = $arguments->{'request'};
	my $lab_name = $request->{'name'};
	my $lab_desc = $request->{'desc'};
	say Dumper ($arguments);
	return (201, $json_encoder->encode(service->create_lab($lab_name, $lab_desc)));
}

sub single_lab_action_GET {
	my ($self, $arguments) = @_;
	my $lab_id = $arguments->{path_args};
	my $lab_entry = service->get_lab_details($lab_id);
	$lab_entry ? (400, $json_encoder->encode($lab_entry)) : (200, $json_encoder->encode("lab with id=$lab_id does not exist."));
}

1;