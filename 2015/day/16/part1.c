// template that's likely to be close to what's required for an AoC puzzle
#include <stdio.h>
#include <string.h>
#define LINE_LENGTH 52 //including '\n' and '\0'
#define N_PROPERTIES 10
#define N_SUES 500

// global variables
int sues[N_SUES][N_PROPERTIES]; // -1 for NA
int possible_sues_i[N_SUES]; // for index of sues still in contention
int possible_sues_n = N_SUES; // the number of possible sues

// function prototypes
int get_property_index(char *property);
void print_sues_row(int row);

// default input file
#define INPUT_FILE "input"

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
	
	// initialise arrays
	for (int i = 0; i < N_SUES; i++)
	{
		for (int j = 0; j < N_PROPERTIES; j++)
		{
			sues[i][j] = -1;
		}
	}
	
	for (int i = 0; i < N_SUES; i++)
	{
		possible_sues_i[i] = i;
	}
	
	// Read the file contents and store parsed results into `sues` matrix
	char line[LINE_LENGTH];
	char *token;
	char property[13];
	int value;
	int row = 0;
	int col;
	
	while (fgets(line, LINE_LENGTH, fptr)) 
	{
		token = strtok(line, ":"); // get past "Sue n:"
		//printf("%s\n", token);
		token = strtok(NULL, ",");
		
		while(token != NULL)
		{
			//printf("%s\n", token);
			//sscanf(token, "%s: %d", property, &value);
			sscanf(token, " %12[^:] %*c %d", property, &value);
			//printf("%s %d\n", property, value);		
			token = strtok(NULL, ",");
			
			col = get_property_index(property);
			if (col == N_PROPERTIES)
			{
				printf("invalid property!\n");
				return 1;
			}
			
			// update `sues`
			sues[row][col] = value;
		}
		
		row++;
	}
	
	print_sues_row(0);
	print_sues_row(N_SUES - 1);
	
	// close the file
	fclose(fptr);
	
	// print out the answer
	printf("%d\n", possible_sues_i[0] + 1);
}

// function to get col index of a property
int get_property_index(char *property)
{
	char *properties[N_PROPERTIES] = {"children", "cars", "vizslas", "akitas", "perfumes",
                        "pomeranians", "goldfish", "cats", "trees", "samoyeds"};
	for (int i = 0; i < N_PROPERTIES; i++)
	{
		if (strcmp(property, properties[i]) == 0)
		{
			return i;
		}
	}
	
	printf("property not found!\n");
	return N_PROPERTIES;
}

void print_sues_row(int row)
{
	for (int j = 0; j < N_PROPERTIES; j++)
	{
		printf("%d ", sues[row][j]);
	}
	printf("\n");
}
