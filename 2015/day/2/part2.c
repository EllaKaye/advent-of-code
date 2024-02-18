// template that's likely to be close to what's required for an AoC puzzle
#include <stdio.h>

// default input file
#define INPUT_FILE "input"

int max3(int a, int b, int c);
int process_line(int l, int w, int h);

int main(int argc, char *argv[]) {
	
	// check usage
	if (argc !=1 && argc !=2)
	{
		printf("Usage: ./part2 [INPUT_FILE]\n");
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
	while (fscanf(fptr, "%d%*c%d%*c%d", &length, &width, &depth) == 3) 
	{
		total += process_line(length, width, depth);
	}
	
	// close the file
	fclose(fptr);
	
	// print out the answer
	printf("%d\n", total);
}

// get minimum of three ints
int max3(int a, int b, int c)
{
	int max = a;
	
	if (b > max)
	{
		max = b;
	}
	
	if (c > max)
	{
		max = c;
	}
	
	return max;
}

// get amount of ribbon needed
// which is 2 * (a + b) + a * b * c
// where a and b are the two shortest sides
int process_line(int l, int w, int h)
{
	int max = max3(l, w, h);
	int value;
	int vol = l * w * h;
	
	if (max == l)
	{
		value = 2 * (w + h);
	}
	else if (max == w)
	{
		value = 2 * (l + h);
	}
	else if (max == h)
	{
		value = 2 * (w + l);
	}
	else
	{
		printf("problem with max\n");
		return 1;		
	}
	
	return value + vol;
}
