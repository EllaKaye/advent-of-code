#include <stdio.h>

int main(void) {
	
	FILE *fptr;
	
	// Open a file in read mode
	fptr = fopen("input", "r");
	
	// Store the content of the file
	char input_line[7001];
	
	// Set up accumulator
	int total = 0;
	
	// Read the content and store it inside input_line
	fgets(input_line, 7001, fptr); 
	
	int i = 0;
	for (i = 0; i <= 7000; i++) {
		//printf("%d\n", input_line[i]); 
		//printf("%d\n", i); 
		// 40 is ASCII code of (
		if (input_line[i] == 40) {
			total += 1;
			// 41 is ASCII code of )
		} else if (input_line[i] == 41) {
			total -= 1;
		} else {
			break;
		}
		
		if (total < 0) {
			break;
		}
	}
	
	// Close the file
	fclose(fptr);
	
	printf("%d\n", i+1);
}