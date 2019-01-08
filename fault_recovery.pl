#!/usr/bin/perl

use strict;
use warnings;

our $USERNAME = "minecraft";
our $SERVICE  = "minecraft_server.jar";

my $logon = is_logon();
#logger("logon=$logon");
if ($logon) {
	exit 0;
}
if (-f "/data/stop.txt") {
	exit 0;
}

unless (is_alive()) {
	logger("dead found minecraft start");
	`/etc/init.d/minecraft start >/dev/null 2>&1`;
}
exit 0;


sub is_logon
{
	`pgrep -f /bin/bash`;
	return ($? == 0) ? 1 : 0;
}

sub is_alive
{
	my $stdout = `/etc/init.d/minecraft status`;
	return ($stdout =~ /is running/) ? 1 : 0;
}

sub logger
{
	my ($msg) = @_;
	my $date = `date`;
	chomp $date;
	open my $fh, ">>", "/data/fault_recovery.log";
	print $fh "$date : $msg\n";
	close $fh;
}
