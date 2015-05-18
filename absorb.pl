#!/usr/bin/perl

use strict;
use warnings;
use Cwd;

open(NskMirror, "<", ".intake-mirror") or die "Missing .intake-mirror: $!";
my $subvol = '';
while(<NskMirror>) {
	chomp;
	$subvol = $_;
}
close(NskMirror);

print "Importing ", $subvol, " into ", getcwd, "\n";

my $githints = $subvol . "/githints";

open(GitHintsFile, "<", $githints) or die "Missing GITHINTS: $!";
while(<GitHintsFile>) {
	chomp;
	print "Got '", $_, "'\n";
}
close(GitHintsFile);
