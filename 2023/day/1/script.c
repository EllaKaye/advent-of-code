// attempt to solve Part 1 in C

#include <stdio.h>
#include <string.h>

int get_value(char input[]);

FILE *fptr;

// Open a file in read mode
fptr = fopen("example-input", "r");

// Store the content of the file
char my_input[4];

int main(void) {

	char input[] = "seven3find";
	
	int value = get_value(input);
	
	printf("%d\n", value);
}

int get_value(char input[]) {

	int length = strlen(input);

	int value = 0;
	
	for (int i = 0; i < length; i++) {
		// find the first digit
		if (input[i] >= '0' && input[i] <= '9') {
			//printf("%c\n", input[i]);
			// convert to int and update value
			value = (input[i] - '0')*10;
			break;
			
		}
	}
	
	// now find the last digit
	for (int i = length; i > 0; i--) {
		if (input[i] >= '0' && input[i] <= '9') {

			value += (input[i] - '0');
			break;
			
		}
	}
	
	return value;
}



