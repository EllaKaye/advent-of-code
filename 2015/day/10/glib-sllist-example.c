// compile with 
// clang `pkg-config --cflags glib-2.0` -Wall -Wextra glib-sllist-example.c -o glib-sllist-example `pkg-config --libs glib-2.0`
// have now updated Makefile so can just run `makeaoc glib-sllist-example`
#include <glib-2.0/glib.h>

void print_list(GSList *list);

int main(void) {
	// Create a new singly linked list
	GSList *list = NULL;
	
	// Prepend values 1, 2, and 3 to the list
	list = g_slist_prepend(list, GINT_TO_POINTER(1));
	list = g_slist_prepend(list, GINT_TO_POINTER(2));
	list = g_slist_prepend(list, GINT_TO_POINTER(3));
	list = g_slist_prepend(list, GINT_TO_POINTER(4));
	
	// Print the list
	g_print("Original List: ");
	/*
	 for (GSList *iter = list; iter != NULL; iter = g_slist_next(iter)) {
	 g_print("%d ", GPOINTER_TO_INT(iter->data));
	 }	 
	 */
	print_list(list);
	g_print("\n");
	
	// Reverse the list
	list = g_slist_reverse(list);
	
	// Print the reversed list
	g_print("Reversed List: ");
	/*
	 for (GSList *iter = list; iter != NULL; iter = g_slist_next(iter)) {
	 g_print("%d ", GPOINTER_TO_INT(iter->data));
	 }
	 */
	print_list(list);
	g_print("\n");
	
	// Free the memory allocated for the list
	g_slist_free(list);
}

void print_list(GSList *list)
{
	for (GSList *iter = list; iter != NULL; iter = g_slist_next(iter)) {
		g_print("%d ", GPOINTER_TO_INT(iter->data));
	}
}
