#!/usr/bin/perl

package Util::Logger;

use v5.14;
use warnings;

use POSIX qw ( strftime );
use IO::Handle;

our @EXPORT = qw( open close write );

use constant DATE_FORMAT => '%Y-%m-%d %H:%M:%S';
use constant LEVELS => { ERROR => 4,
			 WARN => 3,
			 INFO => 2,
			 DEBUG => 1,};

my $log_file;
my $log_level;

sub open{
	my($self, $path, $level) = @_;
	$log_level = $level;
	
	die "Unknown log level $level ! use one of: ". (keys &LEVELS)  unless (exists &LEVELS->{$level}) ;
	
	open $log_file, '>', $path or die "Log file at $path is not writable: $!";
	$log_file->autoflush(1);
	
	say "Logs available in $path.";
}

sub close{
	say 'Log file closed.';
	close($log_file);
}

sub write_msg{
	my($self, $msg, $level) = @_;
	if (&LEVELS->{$level} >= &LEVELS->{$log_level}){
		print $log_file "\[$level\] ".strftime(DATE_FORMAT, localtime).": $msg\n";
	}
}

1;