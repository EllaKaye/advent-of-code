// template that's likely to be close to what's required for an AoC puzzle
#include <stdio.h>

// default input file
#define INPUT_FILE "input"

int min3(int a, int b, int c);
int process_line(int l, int w, int h);

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
	
	// Set up accumulator
	int total = 0;
	
	// Read the file and store the ints
	int length;
	int width;
	int depth;
	while (fscanf(fptr, "%dx%dx%d", &length, &width, &depth) == 3) 
	{
		total += process_line(length, width, depth);
	}
	
	// close the file
	fclose(fptr);
	
	// print out the answer
	printf("%d\n", total);
}

// get minimum of three ints
int min3(int a, int b, int c)
{
	int min = a;
	
	if (b < min)
	{
		min = b;
	}
	
	if (c < min)
	{
		min = c;
	}
	
	return min;
}

// get amount of paper needed
int process_line(int l, int w, int h)
{
	int value = 2 * (l * w + w * h + h * l) + min3(l*w, w * h, h * l);
	
	return value;
}
