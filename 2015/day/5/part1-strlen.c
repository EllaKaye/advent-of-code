// template that's likely to be close to what's required for an AoC puzzle
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#define LINE_LENGTH 18 //16 letters + '\n' + '\0'

// default input file
#define INPUT_FILE "input"

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
	char input_line[LINE_LENGTH];
	fgets(input_line, LINE_LENGTH, fptr);
	
	printf("line: %s", input_line);
	int n = strlen(input_line);
	printf("line length: %i\n", n);

	for (int i = 0; i < n; i++) {
		printf("%c", input_line[i]);
	}
	
	// close the file
	fclose(fptr);
	
}
