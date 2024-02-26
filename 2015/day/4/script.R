library(aochelpers)
input <- aoc_input_vector(4, 2015) # uncomment at end, once correct on test input
# also consider aoc_input_data_frame() or aoc_input_matrix(), with view = TRUE

browseURL("https://adventofcode.com/2015/day/4")
# use datapasta addin to copy in test input from the website
# triple-click in test input box in the puzzle to select, 
# then choose appropriate paste format from addin
# comment out once ready to run on full input

# input <- 

# Part 1 ---------------------------------------------------------------------

library(openssl)
hash <- md5(input) 
grepl("^dd", hash)

system.time(
	{
		i <- 1
		repeat {
			if (grepl("^00000", md5(paste0(input, i)))) {
				break
			}
			i <- i + 1
		}
		i		
	}
)

# 282749
# takes 6.7 seconds

# solution found online. Is it faster?
# https://www.reddit.com/r/adventofcode/comments/3vdn8a/day_4_solutions/
library(digest)
system.time(which(substr(sapply(paste0(input, 1:5e5), digest, algo = "md5", serialize = FALSE), 1, 5) == "00000"))
# 3.5 secs

# simplify
system.time(
	{
		inputs <- paste0(input, 1:5e5) 
		keys <- grepl("^00000", md5(inputs)) |> which()
		keys[1]		
	}
)
# 0.70 - much faster to use vectorisation than sapply

matching_keys <- inputs |> 
	md5() |> 
	grepl("^00000", x = _) |> 
	which()

system.time(
	{
		inputs <- paste0(input, 1:5e5) 
		matching_keys <- inputs |> 
			md5() |> 
			grepl("^00000", x = _) |> 
			which()		
	}
)
# 0.73
matching_keys[1]

# Part 2 ---------------------------------------------------------------------

system.time(
	{
		i <- 1
		repeat {
			if (grepl("^000000", md5(paste0(input, i)))) {
				break
			}
			i <- i + 1
		}
		i		
	}
)

# 9962624, but it takes 251.6 seconds (over 4 minutes)
system.time(
	{
		inputs <- paste0(input, 1:1e7) 
		keys <- grepl("^000000", md5(inputs)) |> which()		
	}
)
# 18.59 seconds

system.time(inputs <- paste0(input, 1:1e7)) # 2.32 secs
system.time(keys <- grepl("^000000", md5(inputs)) |> which()) # 13.79 secs
keys[1]

system.time(
	{
		inputs <- paste0(input, 1:1e7)
		matching_keys <- inputs |> 
			md5() |> 
			grepl("^000000", x = _) |> 
			which()		
	}
)
matching_keys[1] # only one
# 27.9

# comparing with C approach

paste0(input, 1:4) |> md5()
