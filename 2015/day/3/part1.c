// template that's likely to be close to what's required for an AoC puzzle
#include <stdio.h>
#include <stdbool.h>

// default input file
#define INPUT_FILE "input"

#define MAX 8193 // number of instructions + 1 for origin

typedef struct
{
	int x;
	int y;
} point;

// function prototypes
bool find(point p, point arr[], int num);

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
	point visited[MAX];
	point current;
	current.x = 0;
	current.y = 0;
	visited[0] = current;
	int num_visited = 1;
	
	// read in and process instructions
	char c;
	while ((c = fgetc(fptr)) != EOF) 
	{
		// update current based on instruction
		switch (c) {
			case '>':
				current.x++;
				break;
				
			case '<':
				current.x--;
				break;
		
			case '^':
				current.y++;
				break;
			
			case 'v':
				current.y--;
				break;
			
			default:
				printf("Unexpected char\n");
				return 1;
		}
		
		// look for current in visited and add it if not
		// and incement num_visited
		if (!find(current, visited, num_visited))
		{
			visited[num_visited] = current;
			num_visited++;
		}
	}
	
	// close the file
	fclose(fptr);
	
	// print out the answer
	printf("%d\n", num_visited);
}

bool find(point p, point arr[], int num)
{
	for (int i = 0; i < num; i++) {
		if (p.x == arr[i].x && p.y == arr[i].y) {
			return true;
		}
	}
	
	return false;
}
