// template that's likely to be close to what's required for an AoC puzzle

#include <stdio.h>
#include <string.h>

//int process_line(char input[]);

int main(void) {
	
	FILE *fptr;
	
	// Open a file in read mode
	fptr = fopen("input", "r");
	
	// Store the content of the file
	// MAY NEED TO EXTEND OR REDUCE LENGTH OF STRING
	char input_line[50];
	
	// Set up accumulator
	// OR WHATEVER ELSE IS REQUIRED FOR THE PUZZLE
	int total = 0;
	
	// Read the content and store it inside input_line
	while (fgets(input_line, 50, fptr)) {
		int value = process_line(input_line);
		
		// WHATEVER WE NEED HERE
		//total += value;
		
	}
	
	// Close the file
	fclose(fptr);
	
	printf("%d\n", total);
}

int process_line(char input[]) {
	
	int length = strlen(input);
	int value = 0;
	
	// PROCESS THE LINE!
	
	return value;
}



