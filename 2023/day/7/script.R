library(aochelpers)
library(tidyverse)
input <- aoc_input_data_frame(7, 2023) |>
	rename(hand = X1, bid = X2)

browseURL("https://adventofcode.com/2023/day/7")
# use datapasta addin to copy in test input from the website
# triple-click in test input box in the puzzle to select, 
# then choose appropriate paste format from addin
# comment out once ready to run on full input

input <- tibble::tribble(
						~hand, ~bid,
            "32T3K", 765,
            "T55J5", 684,
             "KK677", 28,
            "KTJJT", 220,
            "QQQJA", 483
           )


# Part 1 ---------------------------------------------------------------------

# split a hand into individual cards and sort them (for rle)
get_cards <- function(hand) {
	strsplit(hand, "") |> 
		unlist() |> 
		sort()
}

cards_list <- lapply(input$hand, get_cards)

# hand types: weakest to strongest, and equivalent sort rle lengths
# 1: high card: 1,1,1,1,1
# 2: one pair: 1,1,1,2
# 3: two pair: 1,2,2
# 4: three of a kind: 1,1,3
# 5: full house: 2,3
# 6: four of a kind, 1,4
# 7: five of a kind, 5

get_hand_type <- function(hand) {
	cards <- get_cards(hand)
	
	card_rle <- rle(cards)$lengths |> 
		sort() |> 
		paste(collapse = "")
	
	case_when(
		card_rle == "11111" ~ 1,
		card_rle == "1112" ~ 2,
		card_rle == "122" ~ 3,
		card_rle == "113" ~ 4,
		card_rle == "23" ~ 5,
		card_rle == "14" ~ 6,
		card_rle == "5" ~ 7
	)

}

# When nwriting up, make note about why using `identical` `all.equal` doesn't work

#card_rles <- lapply(input$hand, get_hand_type)
#all.equal(card_rles[[1]], c(1,1,1,2))

# card_names <- paste0("card", 1:5)

card_value <- function(card) {
	match(card, c(2:9, "T", "J", "Q", "K", "A"))
}

card_value("2")

input |> 
	rowwise() |> # since get_hand_type isn't vectorised
	mutate(hand_type = get_hand_type(hand)) |> 
	arrange(hand_type) |> 
	separate_wider_position(hand, c(card1 = 1, card2 = 1, card3 = 1, card4 = 1, card5 = 1)) |> 
	#separate_wider_delim(hand, "''", names = paste0("card", 1:5))|> 
	mutate(across(starts_with("card"), card_value)) |> 
	group_by(hand_type) |> 
	arrange(hand_type, card1, card2, card3, card4, card5) |> 
	ungroup() |> 
	mutate(rank = row_number()) |> 
	mutate(winnings = bid * rank) |> 
	summarise(total_winnings = sum(winnings)) |> 
	pull(total_winnings)


# Part 2 ---------------------------------------------------------------------

card_value_joker <- function(card) {
	match(card, c("J", 2:9, "T", "Q", "K", "A"))
}

# need a function that works out hand type if there's a joker

# think about what happens with original hand
# 1: high card: 1,1,1,1,1, turn the jack into one of the other hands, it becomes a one pair
# 2: one pair: 1,1,1,2:
	# if there's only 1 J, make it the same as the pair for three of a kind
	# if there are 2 Js, that's the '2', so they can group with one of the ones, also three of a kind
# 3: two pair: 1,2,2
	# if there's 1 J, becomes full house
	# if there are 2 Js, becomes four of a kind
# 4: three of a kind: 1,1,3
	# if there's 1 J, becomes four of a kind
	# if there are 3 Js, also becomes four of a kind
# 5: full house: 2,3
	# either 2 or 3 Js, in either case, becomes five of a kind
# 6: four of a kind, 1,4
	# either 1 or 4 Js, in either case, becomes five of a kind
# 7: five of a kind, 5: would be JJJJJ, cannot be improved

get_hand_type_joker <- function(hand) {
	cards <- get_cards(hand)
	
	# number of jokers
	n_j = sum(cards == "J")
	
	card_rle <- rle(cards)$lengths |> 
		sort() |> 
		paste(collapse = "")
	
	# get hand rank regardless of joker
	rank <- case_when(
		card_rle == "11111" ~ 1,
		card_rle == "1112" ~ 2,
		card_rle == "122" ~ 3,
		card_rle == "113" ~ 4,
		card_rle == "23" ~ 5,
		card_rle == "14" ~ 6,
		card_rle == "5" ~ 7
	)
	
	# think about what happens with original hand
	# 1: high card: 1,1,1,1,1, turn the jack into one of the other hands, it becomes a one pair
	# 2: one pair: 1,1,1,2:
		# if there's only 1 J, make it the same as the pair for three of a kind
		# if there are 2 Js, that's the '2', so they can group with one of the ones, also three of a kind
	# 3: two pair: 1,2,2
		# if there's 1 J, becomes full house
		# if there are 2 Js, becomes four of a kind
	# 4: three of a kind: 1,1,3
		# if there's 1 J, becomes four of a kind
		# if there are 3 Js, also becomes four of a kind
		# could also make full house, but four of a kind is better
	# 5: full house: 2,3
		# either 2 or 3 Js, in either case, becomes five of a kind
	# 6: four of a kind, 1, 4
		# either 1 or 4 Js, in either case, becomes five of a kind
	# 7: five of a kind, 5: would be JJJJJ, cannot be improved
	
	# adjust if there are jokers
	if (n_j > 0) {
		rank <- case_when(
			rank == 1 ~ 2,
			rank == 2 ~ 4,
			rank == 3 && n_j == 1 ~ 5,
			rank == 3 && n_j == 2 ~ 6,
			rank == 4 ~ 6,
			rank == 5 ~ 7,
			rank == 6 ~ 7,
			rank == 7 ~ 7
		)
	}
	
	rank
}

input |> 
	rowwise() |> # since get_hand_type isn't vectorised
	mutate(hand_type = get_hand_type_joker(hand)) |> 
	arrange(hand_type) |>
	separate_wider_position(hand, c(card1 = 1, card2 = 1, card3 = 1, card4 = 1, card5 = 1)) |>
	mutate(across(starts_with("card"), card_value_joker)) |>
	group_by(hand_type) |>
	arrange(hand_type, card1, card2, card3, card4, card5) |>
	ungroup() |>
	mutate(rank = row_number()) |>
	mutate(winnings = bid * rank) |>
	summarise(total_winnings = sum(winnings)) |>
	pull(total_winnings) |>
	I()


