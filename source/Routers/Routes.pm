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
		'\/labs\/(\d+)$' => sub { lab_controller->single_lab_action(@_); },
		'^/labs$' => sub { lab_controller->all_labs_action(@_); },
		
		'_404' => sub { error_controller->_404; },
	);
}

1;