// template that's likely to be close to what's required for an AoC puzzle
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#define LINE_LENGTH 18 //16 letters + '\n' + '\0'

// default input file
#define INPUT_FILE "input"

bool is_vowel(const char letter);
bool process_line(const char line[]);

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
	
	// Count of nice strings
	int total = 0;
	
	// Read the content and store it inside input_line buffer
	char input_line[LINE_LENGTH];
	while (fgets(input_line, LINE_LENGTH, fptr)) 
	{
		// for each line, determine if nice
		if(process_line(input_line)) {
			total++;
		}
	}
	
	// close the file
	fclose(fptr);
	
	// print out the answer
	printf("%d\n", total);
}

bool is_vowel(const char letter)
{
	return (letter == 'a' || letter == 'e' || letter == 'i' || letter == 'o' || letter == 'u');
}

// true if the line is nice, false otherwise
bool process_line(const char line[]) {
	//return has_enough_vowels(line) && has_repeated_letter(line) && no_disallowed_pairs(line);
	
	int vowel_count = 0;
	bool repeated_letter = false;
	bool disallowed_pair = false;
	
	// only iterate to < n - 1 to avoid going out-of-bounds when checking line[i + 1]
	// N.B. penultimate character in line is `\n`
	// so although only iterating to < n - 1, 
	// we still iterate over all the letters
	for (int i = 0, n = strlen(line); i < n - 1; i++) {
		// check for vowels
		if (is_vowel(line[i])) {
			vowel_count++;
		}
		
		// check for repeated letter
		if (line[i] == line[i + 1]) {
			repeated_letter = true;
		}
		
		// check no disallowed pairs
		if ((line[i] == 'a' && line[i + 1] == 'b') ||
      (line[i] == 'c' && line[i + 1] == 'd') ||
      (line[i] == 'p' && line[i + 1] == 'q') ||
      (line[i] == 'x' && line[i + 1] == 'y')
		) {
			disallowed_pair = true;
		}
	}
	
	// return
	return (vowel_count >= 3 && repeated_letter && !disallowed_pair);
}

