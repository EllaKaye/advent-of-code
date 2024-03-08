#include <stdio.h>
#include <string.h>

int main(void)
{
	char line[52] = "Sue 1: children: 1, cars: 8, vizslas: 7";
	printf("%s\n", line);
	
	char *token;
	char property[13];
	int value;
	
	token = strtok(line, ":");
	//printf("%s\n", token);
	token = strtok(NULL, ",");
	
	while(token != NULL)
	{
		//printf("%s\n", token);
		//sscanf(token, "%s: %d", property, &value);
		sscanf(token, " %12[^:] %*c %d", property, &value);
		printf("%s\n%d\n", property, value);		
		token = strtok(NULL, ",");
	}
}
