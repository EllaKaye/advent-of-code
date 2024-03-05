// template that's likely to be close to what's required for an AoC puzzle
#include <stdio.h>
#include <string.h>
#include <glib-2.0/glib.h>

void look_say(GSList *list);
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
	
	// iterate over look:
	int length = 1; // to store length of a run in the rle
	int current;
	int next;
	
	for (GSList *iter = look; iter->next != NULL; iter = g_slist_next(iter)) {
		
		current = GPOINTER_TO_INT(iter->data);
		next = GPOINTER_TO_INT(g_slist_next(iter)->data);
		
	//	g_print("current: %d, next: %d\n", current, next);
		if (current == next) {
			length++;
			// g_print("Same value\n");
		} 
		else 
		{
			// prepend value and length to say and reset
			say = g_slist_prepend(say, GINT_TO_POINTER(length));
			say = g_slist_prepend(say, GINT_TO_POINTER(current));
			length = 1;
		}
		// g_print("say: ");
		// print_list(say);
		// g_print("\n");
	}
	
	// after loop, deal with final value in the list
	if (current == next) 
	{
		say = g_slist_prepend(say, GINT_TO_POINTER(length));
		say = g_slist_prepend(say, GINT_TO_POINTER(current));
	}
	else // next != current
	{
		// length one of the final value
		say = g_slist_prepend(say, GINT_TO_POINTER(1));
		say = g_slist_prepend(say, GINT_TO_POINTER(next));
	}
	
	//
	g_print("After loop: \n");
	say = g_slist_reverse(say);
	g_print("look: ");
	print_list(look);
	g_print("\n");
	g_print("say: ");
	print_list(say);
	g_print("\n");
	
	
	// free lists
	
	// print out the answer
	// printf("%d\n", total);
}

// given a pointer to `look` as an input
// calculates `say`
// then sets `look` to be `say`, in readiness for next iteration
void look_say(GSList *list)
{
	
}

void print_list(GSList *list)
{
	for (GSList *iter = list; iter != NULL; iter = g_slist_next(iter)) 
	{
		g_print("%d ", GPOINTER_TO_INT(iter->data));
	}
}



