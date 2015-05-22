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

my $workingcache=getcwd;
print "Importing ", $subvol, " into ", $workingcache, "\n";

my $githints = $subvol . "/githints";
my $cachehints = $workingcache . "/githints";

print "Importing githints\n";
system("./fromnsk --from=$githints --to=$cachehints");

open(GitHintsFile, "<", $githints) or die "Missing GITHINTS: $!";
while(<GitHintsFile>) {
	chomp;
	my $str = $_;
	my($nskname, $ossname, $filecode) = split / +/, $str;
	my $fromname = $subvol . "/" . $nskname;
	my $toname = $workingcache . "/" . $ossname;
	print "Importing ", $fromname, " to ", $toname, "\n";
	system("./fromnsk --from=$fromname --to=$toname");
}
close(GitHintsFile);
