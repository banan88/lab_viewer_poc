#!/usr/bin/perl

use v5.14;
use warnings;

package Routers::Routes;

our @EXPORT = qw ( route_mapping );

use Controllers::LabController;
use Controllers::ErrorController qw (_404 );

use constant lab_controller => 'Controllers::LabController';
use constant error_controller => 'Controllers::ErrorController';

sub route_mapping{
	(
		'\/labs\/(\d+)$' => sub { lab_controller->get_lab_details(@_); },
		'^/labs$' => sub { lab_controller->get_all_labs; },
		
		'_404' => sub { error_controller->_404; },
	);
}

1;