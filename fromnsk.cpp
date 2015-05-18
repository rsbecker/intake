#include <stdio.h>
#include <stdlib.h>

static void usage(char *progname) {
	fprintf(stderr, "usage: %s from-nsk-file to-oss-file\n", progname);
	exit(1);
}

int main(int argc, char **argv) {
	FILE *source;
	FILE *dest;

	if (argc != 3)
		usage(argv[0]);

	source = fopen(argv[1], "rb");
	if (!source) {
		perror(argv[1]);
		exit(1);
	}
	dest = fopen(argv[2], "wb");
	if (!dest) {
		perror(argv[2]);
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

	fprintf(stderr, "%d bytes transfered\n", total);
	return 0;
}

