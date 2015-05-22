#!/usr/bin/perl
# This software code is owned and operated by Nexbridge Inc. and has been
# contributed to ITUGLIB. You are free to modify it, providing that you
# communicate the changes back to Nexbridge Inc. for inclusion into the
# main code branch. This code is subject to the ECLIPSE Public License
# and all the rights and obligations contained therein. You must
# preserve this license file and copyright statements in all copyright
# notices in source files.
#
# This software is provided without waranty or fitness of any kind. You
# are entirely responsible for any problems that might occur resulting
# from its use.
#
# Copyright (c) 2015 Nexbridge Inc.


use strict;
use warnings;
use Cwd;
use Cwd 'abs_path';
use File::Basename;

my $workingcache = getcwd;
my $bindir = dirname(abs_path($0));

print "Attempting to commit the contribution...\n";

open(NskMirror, "<", ".intake-mirror") or die "Missing .intake-mirror: $!";
my $subvol = '';
while(<NskMirror>) {
        chomp;
        $subvol = $_;
}
close(NskMirror);

print "Checking commit comment...\n";
my $commit = $subvol . "/commit";
if (! -e $commit) {
	print "Missing commit message file in $commit\n";
	exit(2);
}

0 == system("git commit -F $commit") or die "Unable to commit. Check git output";

