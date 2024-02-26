// template that's likely to be close to what's required for an AoC puzzle
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>

// default input file
#define INPUT_FILE "input"

typedef struct
{
	int x;
	int y;
} point;

typedef struct sllist
{
	point p;
	struct sllist *next;
} node;

// function prototypes
node* create(point pt);
bool find(node *list, point pt);
node* insert(node *list, point pt);
void destroy(node *list);

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
	point current;
	current.x = 0;
	current.y = 0;
	
	node *visited = create(current);	
	
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
		if (!find(visited, current))
		{
			visited = insert(visited, current);
			num_visited++;
		}
	}
	
	// close the file
	fclose(fptr);
	
	// free memory for list
	destroy(visited);
	// set dangling pointer to NULL
	visited = NULL;	
	
	// print out the answer
	printf("%d\n", num_visited);
}

// create a linked list
node* create(point pt) {
	node *new = malloc(sizeof(node));
	if (new == NULL) {
		printf("Could not allocate space for new node\n");
		return NULL;
	}
	
	new->p = pt;
	new->next = NULL;
	
	return new;
}

// find a point in the list
bool find(node *list, point pt) {
	node *ptr = list;
	
	while(ptr != NULL)
	{
		if(ptr->p.x == pt.x && ptr->p.y == pt.y)
		{
			return true;
		}
		else
		{
			ptr = ptr->next;
		}
	}
	
	return false;
}

// insert a new node at the start of the list
node* insert(node *list, point pt)
{
	node *new = malloc(sizeof(node));
	if (new == NULL)
	{
		printf("Could not allocate space for new node\n");
		return NULL;
	}
	
	new->p = pt;
	new->next = list;
	list = new;
	
	return list;
}

void destroy(node *list)
{
	while (list != NULL)
	{
		node *temp = list->next;
		free(list);
		list = temp;
	}
}
