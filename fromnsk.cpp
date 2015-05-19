#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "version.h"

static void usage(char *progname) {
	fprintf(stderr, "usage: %s [options] from-nsk-file to-oss-file\n", progname);
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

