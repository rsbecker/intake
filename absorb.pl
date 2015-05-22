#!/usr/bin/perl

use strict;
use warnings;
use Cwd;
use Cwd 'abs_path';
use File::Basename;

my $workingcache = getcwd;
my $bindir = dirname(abs_path($0));

open(NskMirror, "<", ".intake-mirror") or die "Missing .intake-mirror: $!";
my $subvol = '';
while(<NskMirror>) {
	chomp;
	$subvol = $_;
}
close(NskMirror);

print "Importing ", $subvol, " into ", $workingcache, "\n";

my $githints = $subvol . "/githints";
my $cachehints = $workingcache . "/githints";

print "Importing githints\n";
system("$bindir/fromnsk --from=$githints --to=$cachehints");
system("touch -r $githints $cachehints");
system("git add $cachehints");

print "Importing license\n";
system("$bindir/fromnsk --from=$subvol/license --to=$workingcache/license");
system("touch -r $subvol/license $workingcache/license");
system("chmod --reference=$subvol/license $workingcache/license");
system("git add $workingcache/license");

open(GitHintsFile, "<", $githints) or die "Missing GITHINTS: $!";
while(<GitHintsFile>) {
	chomp;
	my $str = $_;
	my($nskname, $ossname, $filecode) = split / +/, $str;
	my $fromname = $subvol . "/" . $nskname;
	my $toname = $workingcache . "/" . $ossname;
	print "Importing ", $fromname, " to ", $toname, "\n";
	system("$bindir/fromnsk --from=$fromname --to=$toname");
	system("touch -r $fromname $toname");
	system("chmod --reference=$fromname $toname");
	system("git add $toname");
}
close(GitHintsFile);

chdir $workingcache or die "Unable to change to repository: $!";
system("git status");

print "Check whether git is ok and then commit\n";
