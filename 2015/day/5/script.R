library(aochelpers)
input <- aoc_input_vector(5, 2015) # uncomment at end, once correct on test input
# also consider aoc_input_data_frame() or aoc_input_matrix(), with view = TRUE

browseURL("https://adventofcode.com/2015/day/5")
# use datapasta addin to copy in test input from the website
# triple-click in test input box in the puzzle to select, 
# then choose appropriate paste format from addin
# comment out once ready to run on full input

# input <- 

# Part 1 ---------------------------------------------------------------------

## with stringr
library(stringr)

has_enough_vowels <- function(string) {
	if (str_count(string, "[aeiou]") >= 3) {
		return(TRUE)
	} 
	FALSE
}

has_enough_vowels("aeiouaeiouaeiou")
has_enough_vowels("dvszwmarrgswjxmb")

has_repeated_letter <- function(string) {
	str_detect(string, "([a-z])\\1")
}

has_repeated_letter("abcdde")
has_repeated_letter("abcde")

no_disallowed_pairs <- function(string) {
	!str_detect(string, "ab|cd|pq|xy")
}

no_disallowed_pairs("haegwjzuvuyypxyu") # should be FALSE
no_disallowed_pairs("bce") # should be TRUE

is_nice <- function(string) {
	has_enough_vowels(string) && 
		has_repeated_letter(string) && 
		no_disallowed_pairs(string)
}

is_nice("ugknbfddgicrmopn") # TRUE
is_nice("aaa") # TRUE
is_nice("jchzalrnumimnmhp") # FALSE
is_nice("haegwjzuvuyypxyu") # FALSE
is_nice("dvszwmarrgswjxmb") # FALSE

input |> 
	sapply(is_nice) |> 
	sum()

input |> 
	sapply(has_repeated_letter) |> 
	sum()

input |> 
	sapply(no_disallowed_pairs) |> 
	sum()

## base R

# Part 2 ---------------------------------------------------------------------

# a pair of any two letters that appears at least twice without overlapping

s1 <- "xyxy" # should be TRUE
s2 <- "aabcdefgaa" # should be TRUE
s3 <- "aaa" # should be FALSE (overlapping)
pattern <- "(..).*\\1"
str_detect(s1, pattern) # TRUE
str_detect(s2, pattern) # TRUE
str_detect(s3, pattern) # FALSE

has_repeated_pair <- function(string) {
	str_detect(string, "(..).*\\1")
}
has_repeated_pair(s1)
has_repeated_pair(s2)
has_repeated_pair(s3)

# contains at least one letter which repeats with one letter in-between
has_separated_pair <- function(string) {
	str_detect(string, "(.).\\1")
}
has_separated_pair("xyx")
has_separated_pair("abcdefeghi")
has_separated_pair("aaa")

is_now_nice <- function(string) {
	has_repeated_pair(string) && has_separated_pair(string)
}

is_now_nice("qjhvhtzxzqqjkmpb") # TRUE
is_now_nice("xxyxx") # TRUE
is_now_nice("uurcxstgmygtbstg") # FALSE
is_now_nice("ieodomkazucvgmuy") # FALSE

input |> 
	sapply(is_now_nice) |> 
	sum()
