#include <stdio.h>

int main(void) {
	
	FILE *fptr = fopen("input", "r");
	if (fptr == NULL)
	{
		perror("Could not open file");
		return 1;
	}
	
	int i = 0; // to keep track of position
	int total = 0;
	
	char c;
	while((c = fgetc(fptr)) != EOF) 
	{
		if (c == '(') 
		{
			total++;
		} 
		else if (c == ')') 
		{
			total--;
		} 
		else 
		{
			printf("Not a valid char\n");
			break;
		}
		
		i++;
		
		if (total < 0) {
			break;
		}
	}

	// Close the file
	fclose(fptr);
	
	printf("%d\n", i);
}
