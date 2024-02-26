// makeaoc perl_regex_match LIBS=-lpcre2-8

#define PCRE2_CODE_UNIT_WIDTH 8

#include <stdio.h>
#include <pcre2.h>
#include <string.h>
#include <stdbool.h>

bool regex_match(char pat[], char str[]);

int main(int argc, char *argv[])
{
	// check usage
	if (argc != 3)
	{
		printf("Usage: ./perl_regex_match [PATTERN] [STRING]\n");
		return 1;		
	}
	if (regex_match(argv[1], argv[2]))
	{
		printf("Found %s in %s!\n", argv[1], argv[2]);
	}
	else
	{
		printf("Did not find %s in %s!\n", argv[1], argv[2]);			
	}	
}

bool regex_match(char pat[], char str[])
{
	//printf("pattern: %s\nstring: %s\n", pat, str);
	pcre2_code *re; // where compiled regex will be stored
	PCRE2_SPTR pattern = (PCRE2_SPTR)pat;     /* PCRE2_SPTR is a pointer to unsigned code units of */
	PCRE2_SPTR subject = (PCRE2_SPTR)str;
	size_t subject_length = strlen(str);
	pcre2_match_data *match_data;
	
	int errornumber;
	PCRE2_SIZE erroroffset;
	
	// compile the regex
	re = pcre2_compile(
		pattern,               /* the pattern */
		PCRE2_ZERO_TERMINATED, /* indicates pattern is zero-terminated */
		0,                     /* default options */
		&errornumber,          /* for error number */
		&erroroffset,          /* for error offset */
		NULL);                 /* use default compile context */
	
	// Compilation failed: print the error message and exit. 
	if (re == NULL)
	{
		PCRE2_UCHAR buffer[256];
		pcre2_get_error_message(errornumber, buffer, sizeof(buffer));
		printf("PCRE2 compilation failed at offset %d: %s\n", (int)erroroffset, buffer);
		exit(0);
	}
	
	// Do the match
	match_data = pcre2_match_data_create_from_pattern(re, NULL);
	
	int rc = pcre2_match(
		re,                   /* the compiled pattern */
		subject,              /* the subject string */
		subject_length,       /* the length of the subject */
		0,                    /* start at offset 0 in the subject */
		0,                    /* default options */
		match_data,           /* block for storing the result */
		NULL);                /* use default match context */
	
	if (rc < 0)
	{
		switch(rc)
		{
		case PCRE2_ERROR_NOMATCH: printf("No match\n"); break;
		/*
		 Handle other special cases if you like
		 */
		default: printf("Matching error %d\n", rc); break;
		}
		pcre2_match_data_free(match_data);   /* Release memory used for the match */
		pcre2_code_free(re);                 /* data and the compiled pattern. */
		return false;
	} 
	else // match found
	{
		return true;		
	}
}
