library(tidyverse)

progress_path <- here::here("2015", "progress.csv")

# Start the CSV file
# day <- c(1:25)
# lang <- c("R", "C")
# part <- c(1, 2)
# no_progress <- expand_grid(day, lang, part, complete = FALSE)
# write_csv(no_progress, progress_path)

# Update manually in the CSV file 
# have done a few by the time I got round to writing this script!
progress <- read_csv(progress_path)

# function to update the remaining lines manually from here
update_progress <- function(df, DAY, LANG, PART, COMPLETE) {
	df |> 
		mutate(complete = case_when(
			day == DAY & lang == LANG & part == PART ~ COMPLETE,
			.default = complete
		))
}

# update progress csv
# because this script ends by saving to progress.csv and starts by reading it back in,
# we can update the update_progess lines 
# (i.e. don't need to keep the full pipe)
progress <- progress |> 
	update_progress(20, "R", 1, TRUE) |> 
	update_progress(20, "R", 2, TRUE) 

# update csv
write_csv(progress, progress_path)
