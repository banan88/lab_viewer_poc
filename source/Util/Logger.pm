#!/usr/bin/perl

package Util::Logger;

use v5.14;
use warnings;

use IO::Handle;

our @EXPORT = qw( open close write );

my $LOG_FILE;

sub open{
	my $path = $_[-1];
	open $LOG_FILE, '>', $path or die "Log file at $path is not writable: $!";
	$LOG_FILE->autoflush(1);
	
	say "Logs available in $path.";
}

sub close{
	say 'Log file closed.';
	close($LOG_FILE);
}

sub write_msg{
	my($self, $msg, $level) = @_;
	print $LOG_FILE $msg."\n";
	
}

1;