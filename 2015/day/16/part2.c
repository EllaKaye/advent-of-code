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
void filter_sues(char *property, int value, char comp);

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
	
	// close the file
	fclose(fptr);
	
	// for each property, narrow down the list of possible sues
	filter_sues("children", 3, '=');
	filter_sues("cats", 7, '>');
	filter_sues("samoyeds", 2, '=');
	filter_sues("pomeranians", 3, '<');
	filter_sues("akitas", 0, '=');
	filter_sues("vizslas", 0, '=');
	filter_sues("goldfish", 5, '<');
	filter_sues("trees", 3, '>');
	filter_sues("cars", 2, '=');
	filter_sues("perfumes", 1, '=');
	
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

void filter_sues(char *property, int value, char comp)
{
	int new_possible_sues_i[possible_sues_n];
	int new_possible_sues_n = 0;
	int row;
	int col = get_property_index(property);
	
	// loop over rows indexed by possible_sue_i, storing indices where property matches value
	for (int i = 0; i < possible_sues_n; i++)
	{
		// get row from possible_sues_i
		row = possible_sues_i[i];
		
		if (comp == '=')
		{
			// get value from `sues` and check against value
			if (sues[row][col] == value || sues[row][col] == -1)
			{
				new_possible_sues_i[new_possible_sues_n] = possible_sues_i[i];
				new_possible_sues_n++;
			}			
		}
		else if (comp == '<')
		{
			// get value from `sues` and check against value
			if (sues[row][col] < value || sues[row][col] == -1)
			{
				new_possible_sues_i[new_possible_sues_n] = possible_sues_i[i];
				new_possible_sues_n++;
			}					
		}
		else if (comp == '>')
		{
			// get value from `sues` and check against value
			if (sues[row][col] > value || sues[row][col] == -1)
			{
				new_possible_sues_i[new_possible_sues_n] = possible_sues_i[i];
				new_possible_sues_n++;
			}					
		}
		else
		{
			printf("Invalid comparison!\n");
			return;
		}
		

	}
	
	// update global variables
	possible_sues_n = new_possible_sues_n;
	for (int i = 0; i < possible_sues_n; i++)
	{
		possible_sues_i[i] = new_possible_sues_i[i];
	}
	// since possible_sues_i has N_SUES elements
	// good to explicitly assign them all to aid debugging
	for (int i = possible_sues_n; i < N_SUES; i++)
	{
		possible_sues_i[i] = -1;
	}
}
