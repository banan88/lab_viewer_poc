#!/usr/bin/perl

use v5.14;
use warnings;

package Routers::DefaultRouter;

use v5.14;
use warnings;

our @EXPORT = qw( process_request );

use Routers::Routes;
use Regexp::Assemble;


my %routes = Routers::Routes->route_mapping;
my $assembled_re = Regexp::Assemble->new->track->add( keys %routes );


sub process_request{
	my ($self, $request) = @_;
	my $path= rtrim_slashes ( $request->path );
	resolve_sub($path)->($request);
}


sub rtrim_slashes{
	my $url = shift;
	$url =~ s/\/+$//;
	return $url;
}

sub resolve_sub{
	$assembled_re->match(shift); 
	my $found = $assembled_re->matched;
	( defined $found ) ? $routes{$found} : $routes{_404};
}

1;
