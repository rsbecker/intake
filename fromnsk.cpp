/*
 * This software code is owned and operated by Nexbridge Inc. and has been
 * contributed to ITUGLIB. You are free to modify it, providing that you
 * communicate the changes back to Nexbridge Inc. for inclusion into the
 * main code branch. This code is subject to the ECLIPSE Public License
 * and all the rights and obligations contained therein. You must
 * preserve this license file and copyright statements in all copyright
 * notices in source files.
 *
 * This software is provided without waranty or fitness of any kind. You
 * are entirely responsible for any problems that might occur resulting
 * from its use.
 *
 * Copyright (c) 2015 Nexbridge Inc.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "version.h"

static void usage(char *progname) {
	fprintf(stderr, "usage: %s [options] --from=from-nsk-file --to=to-oss-file\n", progname);
	fprintf(stderr, "          --verbose  turns on logging\n");
	fprintf(stderr, "          --version  dumps the version and exits\n");
	exit(1);
}

static void version() {
	printf("Version %s\n", getVersion());
	exit(0);
}

static char *fromFile = NULL;
static char *toFile = NULL;
static bool isVerbose = false;

int main(int argc, char **argv) {
	FILE *source;
	FILE *dest;

	if (argc < 2)
		usage(argv[0]);

	bool isDoingArgs = true;

	for (char **arg = argv+1; *arg; arg++) {
		if (strncmp(*arg, "--", 2) != 0)
			isDoingArgs = false;

		if (isDoingArgs) {
			if (strcmp(*arg, "--version") == 0) {
				version();
			} else if (strcmp(*arg, "--verbose") == 0) {
				isVerbose = true;
			} else if (strncmp(*arg, "--from=", 7) == 0) {
				fromFile = (*arg)+7;
			} else if (strncmp(*arg, "--to=", 5) == 0) {
				toFile = (*arg)+5;
			} else {
				usage(argv[0]);
			}
		} else {
			if (fromFile) {
				if (toFile) {
					usage(argv[0]);
				}
				toFile = *arg;
			} else {
				fromFile = *arg;
			}
		}
	}

	if (!fromFile || !toFile)
		usage(argv[0]);

	source = fopen(fromFile, "rb");
	if (!source) {
		perror(fromFile);
		exit(1);
	}
	dest = fopen(toFile, "wb");
	if (!dest) {
		perror(toFile);
		exit(1);
	}

	char buf[16384];
	size_t len,total;
	total = 0;
	len = fread(buf, sizeof(buf[0]), sizeof(buf), source);
	while (len > 0) {
		fwrite(buf, sizeof(buf[0]), len, dest);
		total += len;
		len = fread(buf, sizeof(buf[0]), sizeof(buf), source);
	}

	fclose(dest);
	fclose(source);

	if (isVerbose)
		fprintf(stderr, "%d bytes transfered from %s to %s\n", total, fromFile, toFile);
	return 0;
}

