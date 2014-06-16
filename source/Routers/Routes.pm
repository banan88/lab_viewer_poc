#!/usr/bin/perl

use v5.14;
use warnings;

package Routers::Routes;

our @EXPORT = qw ( route_mapping );

use Controllers::LabController;
use Controllers::ErrorController;


sub route_mapping{
	(
		'\/labs\/(\d+)$' => sub { Controllers::LabController->get_lab_details},
		'^/labs$' => sub { Controllers::LabController->get_all_labs },
		
		'_404' => sub { Controllers::ErrorController->_404 },
	);
}

1;