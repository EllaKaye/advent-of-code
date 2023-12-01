#include <stdio.h>

int main(void) {
	FILE *fptr;
	
	// Open a file in read mode
	fptr = fopen("example-input", "r");
	
	// Store the content of the file
	char input_line[20];
	
	// Read the content and store it inside input_line
	while (fgets(input_line, 100, fptr) != NULL) {
		printf("%s", input_line);
	}
	
	// Close the file
	fclose(fptr);
	
}

