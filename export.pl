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
print "Expoting ", $subvol, " from ", $workingcache, "\n";

my $githints = $subvol . "/githints";
my $cachehints = $workingcache . "/githints";

print "Exporting githints\n";
system("./tonsk --to=$githints --from=$cachehints --code=101");

open(GitHintsFile, "<", $cachehints) or die "Missing githints: $!";
while(<GitHintsFile>) {
	chomp;
	my $str = $_;
	my($nskname, $ossname, $filecode) = split / +/, $str;
	my $toname = $subvol . "/" . $nskname;
	my $fromname = $workingcache . "/" . $ossname;
	if ($filecode) {
		print "Exporting ", $fromname, " to ", $toname, "(", $filecode, ")\n";
		system("./tonsk --from=$fromname --to=$toname --code=$filecode");
	} else {
		print "Exporting ", $fromname, " to ", $toname, "\n";
		system("./tonsk --from=$fromname --to=$toname");
	}
}
close(GitHintsFile);
