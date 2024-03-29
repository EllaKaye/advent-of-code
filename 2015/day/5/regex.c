// example from https://manual.cs50.io/3/regcomp

#include <stdio.h>
#include <regex.h>
#include <stdint.h>
#include <stdlib.h>

#define ARRAY_SIZE(arr) (sizeof((arr)) / sizeof((arr)[0]))

// A constant pointer to a constant character
// i.e. neither the pointer nor the data can be changed
// static means it's only accessible in this file
static const char *const str =
	"1) John Driverhacker;\n2) John Doe;\n3) John Foo;\n";
static const char *const re = "John.*o";

int main(void)
{
	static const char *s = str;
	regex_t     regex;
	regmatch_t  pmatch[1];
	regoff_t    off, len;
	
	if (regcomp(&regex, re, REG_NEWLINE))
		exit(EXIT_FAILURE);
	
	printf("String = \"%s\"\n", str);
	printf("Matches:\n");
	
	for (int i = 0; ; i++) {
		if (regexec(&regex, s, ARRAY_SIZE(pmatch), pmatch, 0))
			break;
		
		off = pmatch[0].rm_so + (s - str);
		len = pmatch[0].rm_eo - pmatch[0].rm_so;
		printf("#%d:\n", i);
		printf("offset = %jd; length = %jd\n", (intmax_t) off,
         (intmax_t) len);
		printf("substring = \"%.*s\"\n", (int) len, s + pmatch[0].rm_so);
		
		s += pmatch[0].rm_eo;
	}
	
	exit(EXIT_SUCCESS);
}
