library(tidyverse)

day <- c(1:25)
lang <- c("R", "C")
part <- c(1, 2)

no_progress <- expand_grid(day, lang, part, complete = FALSE)
progress_path <- here::here("2015", "progress.csv")
	
write_csv(no_progress, progress_path)
# Update manually in the CSV file 
# have done a few by the time I got round to writing this script!
progress <- read_csv(progress_path)

progress |> 
	filter(!complete) |> 
	nrow()

# function to update the remaining lines manually from here
update_progress <- function(DAY, LANG, PART, COMPLETE) {
	progress |> 
		mutate(complete = case_when(
			day == DAY & lang == LANG & part == PART ~ COMPLETE,
			.default = complete
		))
}

# e.g.
progress <- update_progress(1, "R", 1, TRUE)
progress |> View()
