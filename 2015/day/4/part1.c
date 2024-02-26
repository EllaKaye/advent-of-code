// compile with 
// makeaoc part1 LIBS="-lgcrypt"

// template that's likely to be close to what's required for an AoC puzzle
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <gcrypt.h>
#define LINE_LENGTH 10 //including '\n' and '\0'

// default input file
#define INPUT_FILE "input"

// function prototypes
bool starts_with_5_zeros(const unsigned char *str);

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
	
	// Read the content and store it inside input_line buffer
	char prefix[LINE_LENGTH];
	fgets(prefix, LINE_LENGTH, fptr); // there's only one line
	
	// get rid of newline
	for (int i = 0, n = strlen(prefix); i < n; i++)
	{
		if (prefix[i] == '\n') 
		{
			prefix[i] = '\0';
		}
	}
	
	// for storing the strings and hash
	char key[20];
	int i = 1; // first suffix to try
	char int_str[10];
	unsigned char *hash;
	
	gcry_md_hd_t md5_handle;
	gcry_error_t error;
	
	// loop until find answer
	do 
	{
		// create the key
		sprintf(int_str, "%d", i); // write i as string to int_str
		strcpy(key, prefix); // need to start fresh each loop other get prefix1, prefix12, prefix123 etc
		strcat(key, int_str);
		
		// hash it
		error = gcry_md_open(&md5_handle, GCRY_MD_MD5, 0);
		if (error) 
		{
			fprintf(stderr, "Failed to open MD5 context: %s\n", gcry_strerror(error));
			exit(1);
		}
		
		gcry_md_write(md5_handle, key, strlen(key));
		hash = gcry_md_read(md5_handle, GCRY_MD_MD5);
		
		// get ready for next loop
		i++;
	} while(!starts_with_5_zeros(hash));

	// clean up
	fclose(fptr);
	gcry_md_close(md5_handle);

	// print out the answer
	printf("%i\n", i - 1);
}

bool starts_with_5_zeros(const unsigned char *str)
{
	return (str[0] == 0x00) && (str[1] == 0x00) && (str[2] >> 4 == 0);
}
