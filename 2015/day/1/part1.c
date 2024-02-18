#include <stdio.h>

int main(void) {
	
	FILE *fptr = fopen("input", "r");
	if (fptr == NULL) {
		perror("Could not open file");
		return 1;
	}

	int total = 0;
	
	// Read the file, char by char
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
	}
		
	fclose(fptr);
	
	printf("%d\n", total);
}
