library(aochelpers)
input <- aoc_input_vector(6, 2023) # uncomment at end, once correct on test input
# also consider aoc_input_data_frame() or aoc_input_matrix(), with view = TRUE

browseURL("https://adventofcode.com/2023/day/6")
# use datapasta addin to copy in test input from the website
# triple-click in test input box in the puzzle to select, 
# then choose appropriate paste format from addin
# comment out once ready to run on full input

input <- c("Time:      7  15   30", "Distance:  9  40  200")

input_numbers <- lapply(input, extract_numbers)
times <- input_numbers[[1]]
records <- input_numbers[[2]]

# Part 1 ---------------------------------------------------------------------

total_time <- 7
hold_times <- move_speeds<- 1:7
move_times <- total_times - hold_times
distances <- move_times * move_speeds
distances

num_ways_to_win <- function(time, record) {
	hold_times <- move_speeds<- seq_len(time)
	move_times <- time - hold_times
	distances <- move_times * move_speeds
	
	sum(distances > record)
}

purrr::map2_dbl(times, records, num_ways_to_win) |> prod() # 2374848
system.time(mapply(num_ways_to_win, times, records) |> prod() )

# Part 2 ---------------------------------------------------------------------

time <- paste(times, collapse="") |> as.numeric()
record <- paste(records, collapse="") |> as.numeric()
num_ways_to_win(time, record)
