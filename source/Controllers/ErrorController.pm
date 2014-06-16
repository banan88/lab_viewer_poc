#!/usr/bin/perl

package Controllers::ErrorController;

use v5.14;
use warnings;

use Exporter qw( import );
our @EXPORT = qw( _404 );

use JSON;


my $json_encoder = JSON->new->allow_nonref;

sub _404{
	return (404, $json_encoder->encode('not found'));
}