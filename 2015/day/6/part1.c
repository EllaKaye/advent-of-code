// template that's likely to be close to what's required for an AoC puzzle
#include <stdio.h>
#include <string.h>
// #define LINE_LENGTH 34 //including 'n' and '\0'

// default input file
#define INPUT_FILE "input"

// int process_line(const char line[]);

int main(int argc, char *argv[]) {
	
	// check usage
	if (argc != 1 && argc != 2)
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
	
	// Set up accumulator
	// OR WHATEVER ELSE IS REQUIRED FOR THE PUZZLE
	int total = 0;
	
	// Read the content and store it inside input_line buffer
	// ALTERNATIVES: 
		// read in chars individually with fgetc
		// read in formatted string with fscanf
	char action[11];
	/*
	int x1;
	int y1;
	int x2;
	int y2;
	 */

	//while (fscanf(fptr, "%[^0-9]9s%d%*c%d%*[^0-9]s%d%*c%d", action, &x1, &y1, &x2, &y2) == 5) 
	while (fscanf(fptr, "%[^0-9]10s", action)) 
	{
		// int value = process_line(input_line);
		//printf("Action: %s, %d, %d, %d, %d\n", action, x1, y1, x2, y2);
		printf("Action: %s\n", action);
		
		// WHATEVER WE NEED HERE
		//total += value;
	}
	
	// close the file
	fclose(fptr);
	
	// print out the answer
	printf("%d\n", total);
}

/*

int process_line(const char line[]) {
	
	int value = 0;
	
	// PROCESS THE LINE!
	printf("%s\n", line);
	
	return value;
}
 */
