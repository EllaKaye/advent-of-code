library(aochelpers)
input <- aoc_input_vector(4, 2023) # uncomment at end, once correct on test input
# also consider aoc_input_data_frame() or aoc_input_matrix(), with view = TRUE

browseURL("https://adventofcode.com/2023/day/4")
# use datapasta addin to copy in test input from the website
# triple-click in test input box in the puzzle to select, 
# then choose appropriate paste format from addin
# comment out once ready to run on full input

input <- c("Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53", "Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19", "Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1", "Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83", "Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36", "Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11")
x <- input[5]

library(stringr)

# Part 1 ---------------------------------------------------------------------
n_card_matches <- function(card) {
	card_split <- str_split(card, ":|\\|") |> unlist()
	winning_numbers <- card_split[2] |> 
		str_extract_all("\\d+") |> 
		unlist() |> 
		as.numeric()
	
	my_numbers <- card_split[3] |> 
		str_extract_all("\\d+") |> 
		unlist() |> 
		as.numeric()
	
	sum(my_numbers %in% winning_numbers)
}

n_card_matches(input[5])

card_worth <- function(card) {
	
	n_winners <- card |> 
		n_card_matches() 
	
	ifelse(n_winners == 0, 0, 2^(n_winners-1))
}

sapply(input, card_worth) |> sum()

# Part 2 ---------------------------------------------------------------------

# start with one of each card
n_of_card <- rep(1, length(input))

# loop over number of card:
for (i in seq_along(n_of_card)) {
	
	# get number cards won
	n_won <- n_card_matches(input[i])
	

	# process cards won, if any
	if (n_won > 0) {
		# get indices of cards won:
		# this is a sequence of length n_won, starting at i+1
		cards_won <- (i+1):(i+n_won)
		
		# update n_of_card
		n_of_card[cards_won] <- n_of_card[cards_won] + n_of_card[i]
	} 
}

n_of_card

n_of_card |> sum()
