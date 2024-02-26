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
	point santa_current;
	point robo_santa_current;
	santa_current.x = 0;
	santa_current.y = 0;
	robo_santa_current.x = 0;
	robo_santa_current.y = 0;
	visited[0].x = 0;
	visited[0].y = 0;
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
					santa_current.x++;
					break;
					
				case '<':
					santa_current.x--;
					break;
					
				case '^':
					santa_current.y++;
					break;
					
				case 'v':
					santa_current.y--;
					break;
					
				default:
					printf("Unexpected char\n");
				return 1;
			}
			
			// look for current in visited and add it if not
			// and incement num_visited
			if (!find(santa_current, visited, num_visited))
			{
				visited[num_visited] = santa_current;
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
				robo_santa_current.x++;
				break;
				
			case '<':
				robo_santa_current.x--;
				break;
				
			case '^':
				robo_santa_current.y++;
				break;
				
			case 'v':
				robo_santa_current.y--;
				break;
				
			default:
				printf("Unexpected char\n");
			return 1;
			}
			
			// look for current in visited and add it if not
			// and incement num_visited
			if (!find(robo_santa_current, visited, num_visited))
			{
				visited[num_visited] = robo_santa_current;
				num_visited++;
			}
			
		}
		
		rep++;
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
