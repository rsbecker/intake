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

my $workingcache=getcwd;
print "Exporting ", $subvol, " from ", $workingcache, "\n";

my $githints = $subvol . "/githints";
my $cachehints = $workingcache . "/githints";

print "Exporting githints\n";
system("$bindir/tonsk --to=$githints --from=$cachehints --code=101");
system("touch -r $cachehints $githints");

open(GitHintsFile, "<", $cachehints) or die "Missing githints: $!";
while(<GitHintsFile>) {
	chomp;
	my $str = $_;
	my($nskname, $ossname, $filecode) = split / +/, $str;
	my $toname = $subvol . "/" . $nskname;
	my $fromname = $workingcache . "/" . $ossname;
	if ($filecode) {
		print "Exporting ", $fromname, " to ", $toname, "(", $filecode, ")\n";
		system("$bindir/tonsk --from=$fromname --to=$toname --code=$filecode");
	} else {
		print "Exporting ", $fromname, " to ", $toname, "\n";
		system("$bindir/tonsk --from=$fromname --to=$toname");
	}
	system("touch -r $fromname $toname");
}
close(GitHintsFile);
