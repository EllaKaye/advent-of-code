// template that's likely to be close to what's required for an AoC puzzle
#include <stdio.h>
#include <string.h>

// default input file
#define INPUT_FILE "input"

// constants
#define N_LOCATIONS 8
char *locations[N_LOCATIONS] = {"AlphaCentauri", "Arbre", "Faerun", "Norrath", "Snowdin", "Straylight", "Tambi", "Tristram"};
int dist_mat[N_LOCATIONS][N_LOCATIONS];

// function prototypes
unsigned int location_i(char *loc);
int shortest_path_from_location(char *loc);
void print_dist_mat(void);

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
	
	// Set up accumulator
	// OR WHATEVER ELSE IS REQUIRED FOR THE PUZZLE
	int total = 0;
	
	// Read and save the file content 
	char from[14];
	char to[14];
	int dist;
	
	// fill dist_mat
	/// fill doagonals with zero
	for (int i = 0; i < N_LOCATIONS; i++)
	{
		dist_mat[i][i] = 0;
	}
	
	/// fill off-diagonals from file
	while (fscanf(fptr, "%s to %s = %d", from, to, &dist) == 3) 
	{
		//printf("from %d to %d: %d\n", location_i(from), location_i(to), dist);
		dist_mat[location_i(from)][location_i(to)] = dist;
		dist_mat[location_i(to)][location_i(from)] = dist;
	}
	
	print_dist_mat();
	
	// close the file
	fclose(fptr);
	
	// print out the answer
	printf("%d\n", total);
}

unsigned int location_i(char *loc)
{
	for (unsigned int i = 0; i < N_LOCATIONS; i++)
	{
		if (strcmp(loc, locations[i]) == 0) {
			return(i);
		}
	}
	
	// if haven't found the location
	printf("Not a valid location.\n");
	return N_LOCATIONS;
}

int shortest_path_from_location(char *loc) 
{
	loc_i <- location_i(loc);
	
	// write a not_visited(int loc) function!
}

void print_dist_mat(void)
{
	for (int i = 0; i < N_LOCATIONS; i++)
	{
		for (int j = 0; j < N_LOCATIONS; j++)
		{
			printf("%3d ", dist_mat[i][j]);
		}
	printf("\n");
	}
}

