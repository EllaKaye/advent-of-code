# get current year
current_year <- function() {
	as.character(format(Sys.Date(), "%Y"))
}

# get the input url given day and year
aoc_input_url <- function(day, year = NULL) {
	if (is.null(year)) year <- current_year()
	paste0("https://adventofcode.com/", year, "/day/", day, "/input")
}

# get the url given day and year
aoc_url <- function(day, year = NULL) {
	if (is.null(year)) year <- current_year()
	paste0("https://adventofcode.com/", year, "/day/", day)
}

# get and save the input for a given day and year
# adapted from https://github.com/dgrtwo/adventdrob/blob/main/R/input.R
# for instructions on how to find your session token,
# see https://github.com/dgrtwo/adventdrob/tree/main#installation
# it can then be set with usethis::edit_r_environ()
aoc_get_input <- function(day, year = NULL) {
	if (is.null(year)) year <- current_year()
	
	session <- Sys.getenv("ADVENT_SESSION")
	if (session == "") {
		stop("Must set ADVENT_SESSION in .Renviron")
	}
	
	url <- aoc_input_url(day, year)
	
	year_path <- here::here("input", year)
	path <- paste0(year_path, "/", "day", day, ".txt")
	
	# check if there's a directory for the year in data and create one if not
	if (!dir.exists(year_path)) {
		dir.create(year_path)
	}
	
	req <- httr::GET(url,
		httr::set_cookies(session = session),
		httr::write_disk(path, overwrite = TRUE))
}

# copy post-template to create a new post for a given day and year
aoc_new_post <- function(day, year = NULL) {
	if (is.null(year)) year <- current_year()
	
	# if year directory doesn't exist, create it
	if (!dir.exists(here::here(year))) {
		dir.create(here::here(year))
	}
	
	from_post <- here::here("post-template")
	to_post <- here::here(year, paste0("day", day))
	
	dir.create(to_post)
	file.copy(list.files(from_post, full.names = TRUE),
						to_post,
						recursive = TRUE)
	
	# get index.qmd from the new post
	index <- readLines(paste0(to_post, "/index.qmd"))
	
	# replace YYYY and DD placeholders
	index_with_year <- gsub("YYYY", year, index)
	index_with_day <- gsub("DD", day, index_with_year)
	
	# evaluate reading in the input
	index_with_input <- gsub("eval: false", "eval: true", index_with_day)
	
	# write the updated post
	writeLines(index_with_input, paste0(to_post, "/index.qmd"))
	
}

# delete a post for a given day and year
aoc_delete_post <- function(day, year = NULL) {
	if (is.null(year)) year <- current_year()
	
	post <- here::here(year, paste0("day", day))
	unlink(post, recursive = TRUE)
}

# delete the input for a given day and year
aoc_delete_input <- function(day, year = NULL) {
	if (is.null(year)) year <- current_year()
	
	input <- here::here("input", year, paste0("day", day, ".txt"))
	unlink(input)
}

# aoc_new_day function gets input and creates a new post
aoc_new_day <- function(day, year = NULL) {
	if (is.null(year)) year <- current_year()
	
	aoc_get_input(day, year)
	aoc_new_post(day, year)
}

# aoc_delete_day function deletes input and post
aoc_delete_day <- function(day, year = NULL) {
	if (is.null(year)) year <- current_year()
	
	aoc_delete_input(day, year)
	aoc_delete_post(day, year)
}

# aoc_new_year copies the listing template _YYYY.qmd
# and creates new directories for the posts and input
aoc_new_year <- function(year = NULL) {
	if (is.null(year)) year <- current_year()
	
	# create new directory for the posts, if it doesn't exist
	if (!dir.exists(here::here(year))) {
		dir.create(here::here(year))
	}
	
	# create new directory for the input, if it doesn't exist
	input_path <- here::here("input", year)
	if (!dir.exists(input_path)) {
		dir.create(input_path)
	}
	
	# copy the _YYYY.qmd to year.qmd
	file.copy(here::here("_YYYY.qmd"), here::here(paste0(year, ".qmd")))
	
	# read year.qmd, replace YYYY with the year, then write it as year.qmd
	year_qmd <- readLines(here::here(paste0(year, ".qmd")))
	year_qmd_with_year <- gsub("YYYY", year, year_qmd)
	writeLines(year_qmd_with_year, here::here(paste0(year, ".qmd")))

}
