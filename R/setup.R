# get current year
current_year <- function() {
	as.character(format(Sys.Date(), "%Y"))
}

# get the input url given day and year
aoc_input_url <- function(day, year = NULL, browse = FALSE) {
	if (is.null(year)) year <- current_year()
	url <- paste0("https://adventofcode.com/", year, "/day/", day, "/input")
	if (browse) utils::browseURL(url)
	url
}

# get the url given day and year
aoc_url <- function(day, year = NULL, browse = FALSE) {
	if (is.null(year)) year <- current_year()
	url <- paste0("https://adventofcode.com/", year, "/day/", day)
	if (browse) utils::browseURL(url)
	url
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
	
	year_path <- here::here(year)
	day_path <- paste0(year_path, "/day/", day)
	input_path <- paste0(day_path, "/input")
	
	# check if there's a directory for the year and create one if not
	if (!dir.exists(year_path)) {
		dir.create(year_path)
	}
	
	# check if there's a directory for the day and create one if not
	if (!dir.exists(day_path)) {
		dir.create(day_path, recursive = TRUE)
	}
	
	# get and save the input
	req <- httr::GET(url,
		httr::set_cookies(session = session),
		httr::write_disk(input_path, overwrite = TRUE))
}

# copy post-template to create a new post for a given day and year
aoc_new_post <- function(day, year = NULL) {
	if (is.null(year)) year <- current_year()
	
	year_path <- here::here(year)
	day_path <- paste0(year_path, "/day/", day)
	
	# if year doesn't exist, create it
	if (!dir.exists(year_path)) {
		dir.create(year_path)
	}
	
	# if day doesn't exist, create it
	if (!dir.exists(day_path)) {
		dir.create(day_path, recursive = TRUE)
	}
	
	template_path <- here::here("post-template")

	file.copy(list.files(template_path, full.names = TRUE),
						day_path,
						recursive = TRUE)
	
	# get index.qmd from the new post
	index <- readLines(paste0(day_path, "/index.qmd"))
	
	# replace YYYY and DD placeholders
	index_with_year <- gsub("YYYY", year, index)
	index_with_day <- gsub("DD", day, index_with_year)
	
	# evaluate reading in the input
	index_with_input <- gsub("eval: false", "eval: true", index_with_day)
	
	# write the updated post
	writeLines(index_with_input, paste0(day_path, "/index.qmd"))
	
}

# delete a post for a given day and year
aoc_delete_post <- function(day, year = NULL) {
	if (is.null(year)) year <- current_year()
	
	post <- here::here(year, paste0("day/", day, "/index.qmd"))
	unlink(post, recursive = TRUE)
}

# delete the input for a given day and year
aoc_delete_input <- function(day, year = NULL) {
	if (is.null(year)) year <- current_year()
	
	input <- here::here(year, paste0("day/", day, "/input"))
	unlink(input)
}

# delete post and input for a given day and year
aoc_delete_day <- function(day, year = NULL) {
	if (is.null(year)) year <- current_year()
	
	day <- here::here(year, paste0("day/", day))
	unlink(day, recursive = TRUE)
}

# aoc_new_day function gets input and creates a new post
aoc_new_day <- function(day, year = NULL) {
	if (is.null(year)) year <- current_year()
	
	
	
	aoc_get_input(day, year)
	aoc_new_post(day, year)
}

# aoc_new_year copies the listing template _YYYY.qmd
# and creates new directories for the posts and input
aoc_new_year <- function(year = NULL) {
	if (is.null(year)) year <- current_year()
	
	# create new year directory if it doesn't exist
	if (!dir.exists(here::here(year))) {
		dir.create(here::here(year))
	}
	
	# copy the _YYYY.qmd to year.qmd
	file.copy(here::here("_YYYY.qmd"), here::here(paste0(year, ".qmd")))
	
	# read year.qmd, replace YYYY with the year, then write it as year.qmd
	year_qmd <- readLines(here::here(paste0(year, ".qmd")))
	year_qmd_with_year <- gsub("YYYY", year, year_qmd)
	writeLines(year_qmd_with_year, here::here(paste0(year, ".qmd")))

	# message reminder to update _quarto.yml
	cli::cli_bullets(c(
		"!" = "Don't forget to update _quarto.yml, to list {year}.qmd in the navbar.",
		"!" = "May need to change the color of the header in {year}.qmd to match its navbar link color."))
}

aoc_delete_year <- function(year = NULL) {
	if (is.null(year)) year <- current_year()
	
	year <- here::here(year)
	unlink(year, recursive = TRUE)
	unlink(paste0(year, ".qmd"))
}

