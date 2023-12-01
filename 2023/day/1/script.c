// Advent of Code, Day 1 2023, Part 1 in C

#include <stdio.h>
#include <string.h>

int get_value(char input[]);

int main(void) {
	
	FILE *fptr;
	
	// Open a file in read mode
	fptr = fopen("input", "r");
	
	// Store the content of the file
	char input_line[50];
	
	// Set up accumulator
	int total = 0;
	
	// Read the content and store it inside input_line
	while (fgets(input_line, 50, fptr)) {
		int value = get_value(input_line);
		total += value;
		
	}
	
	// Close the file
	fclose(fptr);
	
	printf("%d\n", total);
}

int get_value(char input[]) {

	int length = strlen(input);

	int value = 0;
	
	// find the first digit	
	for (int i = 0; i < length; i++) {
		if (input[i] > '0' && input[i] <= '9') {

			// convert to int and update value
			value = (input[i] - '0')*10;
			break;
			
		}
	}
	
	// find the last digit
	for (int i = length; i >= 0; i--) {
		if (input[i] > '0' && input[i] <= '9') {

			value += (input[i] - '0');
			break;
			
		}
	}
	
	return value;
}



