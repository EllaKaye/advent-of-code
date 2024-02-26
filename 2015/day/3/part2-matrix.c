// template that's likely to be close to what's required for an AoC puzzle
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>

// default input file
#define INPUT_FILE "input"

// max number of instructions in any one direction + 1 for origin
#define MAX 2086

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
	
	// Keep track of which and how many houses have been visited
	// starting at origin
	// bool visited[2 * MAX + 1][2 * MAX + 1]; // can't do this - exceeds stack size
	
	// Allocate memory for visited array dynamically
	// see this explanation of the approach: 
	// https://chat.openai.com/c/b776a69a-53c7-4b98-86de-3c7523ca2978
	bool **visited = malloc((2 * MAX + 1) * sizeof(bool *));
	for (int i = 0; i < 2 * MAX + 1; i++) {
		visited[i] = malloc((2 * MAX + 1) * sizeof(bool));
	}
	
	// Check if memory allocation was successful
	if (visited == NULL) {
		printf("Memory allocation failed\n");
		return 1;
	}
	
	int santa_x = MAX;
	int santa_y = MAX;
	int robo_santa_x = MAX;
	int robo_santa_y = MAX;
	visited[MAX][MAX] = true;
	int num_visited = 1;
	
	// read in and process instructions
	char c;
	int rep = 1;
	while ((c = fgetc(fptr)) != EOF) 
	{
		// santa
		if (rep % 2) 
		{
			// update current based on instruction
			switch (c) 
			{
			case '>':
				santa_x++;
				break;
				
			case '<':
				santa_x--;
				break;
				
			case '^':
				santa_y++;
				break;
				
			case 'v':
				santa_y--;
				break;
				
			default:
				printf("Unexpected char\n");
			return 1;
			}
			
			// look for current in visited and add it if not
			// and incement num_visited
			if (!visited[santa_x][santa_y])
			{
				visited[santa_x][santa_y] = true;
				num_visited++;
			}
			
		}
		// robo_santa
		else
		{
			// update current based on instruction
			switch (c) 
			{
			case '>':
				robo_santa_x++;
				break;
				
			case '<':
				robo_santa_x--;
				break;
				
			case '^':
				robo_santa_y++;
				break;
				
			case 'v':
				robo_santa_y--;
				break;
				
			default:
				printf("Unexpected char\n");
			return 1;
			}
			
			// look for current in visited and add it if not
			// and incement num_visited
			if (!visited[robo_santa_x][robo_santa_y])
			{
				visited[robo_santa_x][robo_santa_y] = true;
				num_visited++;
			}
			
		}
		
		rep++;
		
	}
	
	// close the file
	fclose(fptr);
	
	// Free dynamically allocated memory
	for (int i = 0; i < 2 * MAX + 1; i++) {
		free(visited[i]);
	}
	free(visited);
	
	// print out the answer
	printf("%d\n", num_visited);
}
