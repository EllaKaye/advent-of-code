library(aochelpers)
input <- aoc_input_vector(20, 2015, mode = "numeric") # uncomment at end, once correct on test input
# also consider aoc_input_data_frame() or aoc_input_matrix(), with view = TRUE

browseURL("https://adventofcode.com/2015/day/20")
# use datapasta addin to copy in test input from the website
# triple-click in test input box in the puzzle to select, 
# then choose appropriate paste format from addin
# comment out once ready to run on full input

# input <- 

# Part 1 ---------------------------------------------------------------------
input 

is_whole <- function(x) {
	x == as.integer(x)
}

sum_factors <- function(n) {
	
	# when n is odd, don't need to check even divisors
	# N.B. will deal with squares later
	if (n %% 2) {
		divisions <- n / seq(1, sqrt(n), by = 2)
	} else {
		# n is even
		divisions <- n / 1:sqrt(n)		
	}

	first_factors <- divisions[which(is_whole(divisions))]
	factors <- c(first_factors, n / first_factors)
	
	factor_sum <- sum(factors)
	
	# sqrt will have been counted twice
	if (is_whole(sqrt(n))) {
		factor_sum <- factor_sum - sqrt(n)
	}
	
	factor_sum 
}

target <- input / 10

system.time(
	{
		num_presents <- 1:700000 |> 
			sapply(sum_factors)
		
		which(num_presents >= target)[1]		
	}
)

# 7.67 secs


# Part 2 ---------------------------------------------------------------------

# Below is not correct. 
# Need to account for fact that each Elf stops delivering after 50 houses
# i.e. Houses > 50 don't get a visit from Elf 1
# and Houses > 100 don't get a visit from Elf 2
# i.e. Houses greater than 100 don't get a visit from Elves 1 and 2
# Houses > 50 * n don't get a visit from Elf n
# i.e. for houses > 50 * n, don't include factor i in sum.
# i.e. for houses > n, don't include factors < n / 50
# n represents number of presents that house n gets (not including multiplication factor)
# House n not visited by elves 1:floor((n/50))

sum_factors2 <- function(n) {
	
	# when n is odd, don't need to check even divisors
	# N.B. will deal with squares later
	if (n %% 2) {
		divisions <- n / seq(1, sqrt(n), by = 2)
	} else {
		# n is even
		divisions <- n / 1:sqrt(n)		
	}
	
	first_factors <- divisions[which(is_whole(divisions))]
	factors <- c(first_factors, n / first_factors)
	
	elves_visited <- factors[factors >= n/50]
	
	#return(elves_visited)
	factor_sum <- sum(elves_visited)
	
	# sqrt will have been counted twice if whole and in elves_visited
	if (is_whole(sqrt(n)) && sqrt(n) %in% elves_visited) {
		factor_sum <- factor_sum - sqrt(n)
	}
	
	factor_sum
}

system.time(
	{
		num_presents <- 1:750000 |> 
			sapply(sum_factors2)
		
		target <- input / 11 # 2636364
		
		which(num_presents >= target)[1]		
	}
)
# 8.5 secs
# 705600

