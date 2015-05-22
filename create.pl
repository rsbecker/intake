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

print "Enter the unique git repository name of the contribution: ";
my $repo = <STDIN>;
chomp $repo; #Get rid of the newline

print "Checking contributions area...\n";
if (! -d "/home/git/contributions") {
	print "Contibutions area does not exist\n";
	exit(2);
}

print "Checking existing contribution...\n";
if (-d "/home/git/contributions/$repo") {
	print "$repo: contibution already exists\n";
	exit(2);
}

printf "Enter the NSK subvol with the contribution (e.g., /G/data/rsb): ";
my $nsksubvol = <STDIN>;
chomp $nsksubvol; # Get rid of the newline

print "Checking contribution for sanity...\n";
if (! -e "$nsksubvol/githints") {
	print "githints: missing from $nsksubvol\n";
	exit(2);
} else {
	print " Found githints\n";
}
if (! -e "$nsksubvol/license") {
	print "license: missing from $nsksubvol\n";
	exit(2);
} else {
	print " Found license\n";
}

my $repodir = "/home/git/contributions/$repo";
print "Creating new contribution $repodir from $nsksubvol\n";

mkdir $repodir or die "Unable to create repository directory";
print "$repodir created\n";
chdir $repodir or die "Unable to switch to repository directory";
0 == system("git init --shared=group") or die "Unable to create repository";

open(NskMirror, ">", ".intake-mirror") or die "Missing .intake-mirror: $!";
print NskMirror  "$nsksubvol\n";
close(NskMirror);

0 == system("git add .intake-mirror") or die "Unable to git add .intake-mirror";

print "$repodir is now set up. You can run absorb.pl from there\n";
