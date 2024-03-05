// template that's likely to be close to what's required for an AoC puzzle
#include <stdio.h>
#include <string.h>
#include <glib-2.0/glib.h>

void look_say(GSList **look, GSList **say);
void print_list(GSList *list);

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
	
	// Set up singly-linked lists for look and see
	GSList *look = NULL;
	GSList *say = NULL;
	
	// Read the content and store it inside input_line buffer
	// ALTERNATIVES: 
	// read in chars individually with fgetc
	// read in formatted string with fscanf
	 
	 char c;
	 while ((c = fgetc(fptr)) != '\n') 
	 {
			look = g_slist_prepend(look, GINT_TO_POINTER(g_ascii_digit_value(c)));
	 }
	 look = g_slist_reverse(look);
	
	// close the file
	fclose(fptr);
	
	g_print("Before function:\n");
	print_list(look);
	g_print("\n");
	look_say(&look, &say);
	g_print("After function:\n");
	print_list(say);
	g_print("\n");
	
	// print out the answer
	printf("%d\n", g_slist_length(say));
	
	// free lists
	g_slist_free(look);
	g_slist_free(say);
	
	// N.B. MEMORY LEAKS, PROBABLY FROM look_say function.
	// Can we rewrite this as a void function that uses pointers?
}

// given a pointer to `look` as list1 and pointer to say as `*say`
// calculates `say`
// then sets `look` to be `say`, in readiness for next iteration
void look_say(GSList **look, GSList **say)
{
	// Clear the existing content of say
	g_slist_free_full(*say, g_free);
	*say = NULL;
	
	// iterate over look:
	int length = 1; // to store length of a run in the rle
	int current;
	int next;
	
	for (GSList *iter = *look; iter->next != NULL; iter = g_slist_next(iter)) {
		
		current = GPOINTER_TO_INT(iter->data);
		next = GPOINTER_TO_INT(g_slist_next(iter)->data);
		
		if (current == next) 
		{
			length++;
		} 
		else 
		{
			// prepend value and length to say and reset
			*say = g_slist_prepend(*say, GINT_TO_POINTER(length));
			*say = g_slist_prepend(*say, GINT_TO_POINTER(current));
			length = 1;
		}
	}
	
	// after loop, deal with final value in the list
	if (current == next) 
	{
		*say = g_slist_prepend(*say, GINT_TO_POINTER(length));
		*say = g_slist_prepend(*say, GINT_TO_POINTER(current));
	}
	else // next != current
	{
		// length one of the final value
		*say = g_slist_prepend(*say, GINT_TO_POINTER(1));
		*say = g_slist_prepend(*say, GINT_TO_POINTER(next));
	}
	
	// reserve say
	*say = g_slist_reverse(*say);
}

void print_list(GSList *list)
{
	for (GSList *iter = list; iter != NULL; iter = g_slist_next(iter)) 
	{
		g_print("%d ", GPOINTER_TO_INT(iter->data));
	}
}



