library(aochelpers)
input <- aoc_input_vector(6, 2015) # uncomment at end, once correct on test input
# also consider aoc_input_data_frame() or aoc_input_matrix(), with view = TRUE

browseURL("https://adventofcode.com/2015/day/6")
# use datapasta addin to copy in test input from the website
# triple-click in test input box in the puzzle to select, 
# then choose appropriate paste format from addin
# comment out once ready to run on full input

# input <- 

# Part 1 ---------------------------------------------------------------------

lights <- matrix(FALSE, 1000, 1000)

for (line in input) {
	
	coords <- aochelpers::extract_numbers(line)
	x1 <- coords[1] + 1
	y1 <- coords[2] + 1
	x2 <- coords[3] + 1
	y2 <- coords[4] + 1
	
	if (grepl("on", line)) {
		lights[x1:x2, y1:y2] <- TRUE
	} else if (grepl("off", line)) {
		lights[x1:x2, y1:y2] <- FALSE
	} else if (grepl("toggle", line)) {
		lights[x1:x2, y1:y2] <- !lights[x1:x2, y1:y2]
	} else {
		print("Don't know what to do!")
	}
}

sum(lights)

# Part 2 ---------------------------------------------------------------------

brightness <- matrix(0, 1000, 1000)

for (line in input) {
	
	coords <- aochelpers::extract_numbers(line)
	x1 <- coords[1] + 1
	y1 <- coords[2] + 1
	x2 <- coords[3] + 1
	y2 <- coords[4] + 1
	
	if (grepl("on", line)) {
		brightness[x1:x2, y1:y2] <- brightness[x1:x2, y1:y2] + 1
	} else if (grepl("off", line)) {
		brightness[x1:x2, y1:y2] <- pmax(brightness[x1:x2, y1:y2] - 1, 0)
	} else if (grepl("toggle", line)) {
		brightness[x1:x2, y1:y2] <- brightness[x1:x2, y1:y2] + 2
	} else {
		print("Don't know what to do!")
	}
}

sum(brightness)
