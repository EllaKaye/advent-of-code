// see for notes on backreferences 
// https://eli.thegreenplace.net/2012/11/14/some-notes-on-posix-regular-expressions

#include <stdio.h>
#include <stdlib.h>
#include <regex.h>

int matchRegex(const char *string, const char *pattern) {
	regex_t regex;
	int reti;
	
	reti = regcomp(&regex, pattern, REG_EXTENDED);
	if (reti) {
		fprintf(stderr, "Could not compile regex\n");
		exit(1);
	}
	
	reti = regexec(&regex, string, 0, NULL, 0);
	if (!reti) {
		regfree(&regex);
		return 1;
	} else if (reti == REG_NOMATCH) {
		regfree(&regex);
		return 0;
	} else {
		char errorBuffer[100];
		regerror(reti, &regex, errorBuffer, sizeof(errorBuffer));
		fprintf(stderr, "Regex match failed: %s\n", errorBuffer);
		regfree(&regex);
		exit(1);
	}
}

int main(void) {
	const char *string = "abcdde";
	const char *pattern = "(.)\1"; 
	
	if (matchRegex(string, pattern)) {
		printf("String matches the pattern.\n");
	} else {
		printf("String does not match the pattern.\n");
	}
	
	return 0;
}
