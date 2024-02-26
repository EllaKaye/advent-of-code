// compile with
// makeaoc part2 LIBS=-lpcre2-8

// check for memory leaks with
// leaks --atExit -- ./part2     

#define PCRE2_CODE_UNIT_WIDTH 8

#include <stdio.h>
#include <pcre2.h>
#include <string.h>
#include <stdbool.h>

#define LINE_LENGTH 18 //16 letters + '\n' + '\0'

// default input file
#define INPUT_FILE "input"

// fuction prototypes
bool regex_match(const char pat[], const char str[]);
bool process_line(const char line[]);

int main(int argc, char *argv[]) {
	
	// check usage
	if (argc !=1 && argc !=2)
	{
		printf("Usage: ./part1 [INPUT_FILE]\n");
		return 1;		
	}
	
	// determine input file to use
	char *input_file = (argc == 2) ? argv[1] : INPUT_FILE;
	
	// open file in read mode
	FILE *fptr = fopen(input_file, "r");
	if (fptr == NULL)
	{
		printf("Could not open file %s.\n", input_file);
		return 1;
	}
	
	// Count of nice strings
	int total = 0;
	
	// Read the content and store it inside input_line buffer
	char input_line[LINE_LENGTH];
	while (fgets(input_line, LINE_LENGTH, fptr)) 
	{
		// for each line, determine if nice
		if(process_line(input_line)) {
			total++;
		}
	}
	
	// close the file
	fclose(fptr);
	
	// print out the answer
	printf("%d\n", total);
}

bool regex_match(const char pat[], const char str[])
{
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
			case PCRE2_ERROR_NOMATCH: 
				//printf("No match\n"); 
				break;

			default: 
				printf("Matching error %d\n", rc); 
				break;
		}
		
		pcre2_match_data_free(match_data);   /* Release memory used for the match */
		pcre2_code_free(re);                 /* data and the compiled pattern. */
		return false;
	} 
	else // match found
	{
		pcre2_match_data_free(match_data);   /* Release memory used for the match */
		pcre2_code_free(re);                 /* data and the compiled pattern. */
		return true;		
	}
}


// true if the line is nice, false otherwise
bool process_line(const char line[]) 
{
	// regex for a pair of any two letters that appears at least twice 
	// without overlapping
	// (..).*\1
	// but in a string need to escape backslash:
	// "(..).*\\1"
	
	// regex for one letter which repeats with exactly one letter between them
	// (.).\1
	// but in a string need to escape backslash:
	// "(.).\\1"
	
	return regex_match("(..).*\\1", line) && regex_match("(.).\\1", line);
}

