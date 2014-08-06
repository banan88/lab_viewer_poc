#!/usr/bin/perl

use v5.14;
use warnings;

package Routers::DefaultRouter;

use v5.14;
use warnings;

use Exporter qw( import );
our @EXPORT = qw( process_request );

use Regexp::Assemble;
use Routers::Routes;
use Util::Logger;

use constant logger => 'Util::Logger';


my %routes = Routers::Routes->route_mapping;
my $assembled_re = Regexp::Assemble->new->track->add( keys %routes );


sub process_request{
	my ($self, $request) = @_;
	my $path = rtrim_slashes ( $request->path );
	my $method = $request->method;
	
	logger->write_msg($method." $path", 'DEBUG');
	
	my ($target_sub, $path_args) = resolve_sub($path);
	$target_sub->({'request'=> $request, 'path_args'=>$path_args});
}


sub rtrim_slashes{
	my $url = shift;
	$url =~ s/\/+$//;
	return $url;
}

sub resolve_sub{
	my $input = shift;
	$assembled_re->match($input); 
	my $found = $assembled_re->matched;
	get_sub_with_arg($input, $found);
}

sub get_sub_with_arg{
	my($input, $found) = @_;
	my($target_sub, $arg) = ();
	
	if(defined $found){
		if ($input =~ $found){
			$arg = $1;
		}
		$target_sub = $routes{$found};
	} else {
		$target_sub = $routes{_404};
	}
	
	return ($target_sub, $arg);
}

1;
