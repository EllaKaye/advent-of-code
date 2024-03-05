// template that's likely to be close to what's required for an AoC puzzle
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <stdlib.h>
#define SIZE 1000
// #define LINE_LENGTH 34 //including 'n' and '\0'

// default input file
#define INPUT_FILE "input"

int **lights = NULL; 

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
	
	// create lights matrix and initialise to false
	lights = malloc(SIZE * sizeof(int *));
	for (int i = 0; i < SIZE; i++) {
		lights[i] = malloc(SIZE * sizeof(int));
	}
	
	for (int i = 0; i < SIZE; i++)
	{
		for (int j = 0; j < SIZE; j++)
		{
			lights[i][j] = 0;
		}
	}
	
	// Read the content and store it in variables
	char action[11];
	int x1;
	int y1;
	int x2;
	int y2;

	while (fscanf(fptr, "%[^0-9]%d,%d through %d,%d\n", action, &x1, &y1, &x2, &y2) == 5) 
	{
		// deal with "turn on "
		if (strcmp(action, "turn on ") == 0)
		{
			for (int i = x1; i <= x2; i++)
			{
				for (int j = y1; j <= y2; j++)
				{
					lights[i][j]++;
				}
			}
		}
		
		// deal with "turn off "
		else if (strcmp(action, "turn off ") == 0)
		{
			for (int i = x1; i <= x2; i++)
			{
				for (int j = y1; j <= y2; j++)
				{
					lights[i][j]--;
					if (lights[i][j] < 0)
					{
						lights[i][j] = 0;
					}
				}
			}
		}
		
		// deal with "toggle"
		else if (strcmp(action, "toggle ") == 0)
		{
			for (int i = x1; i <= x2; i++)
			{
				for (int j = y1; j <= y2; j++)
				{
					lights[i][j] += 2;
				}
			}
		}
		else
		{
			printf("Invalid action\n");
		}
		
		
	}
	
	// sum over lights to get number lit
	int total = 0;
	for (int i = 0; i < SIZE; i++)
	{
		for (int j = 0; j < SIZE; j++)
		{
			total += lights[i][j];
		}
	}
	
	// close the file
	fclose(fptr);
	
	// Free dynamically allocated memory
	for (int i = 0; i < SIZE; i++) {
		free(lights[i]);
	}
	free(lights);
	
	// print out the answer
	printf("%d\n", total);
}


