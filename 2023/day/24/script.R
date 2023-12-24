library(aochelpers)
# input <- aoc_input_vector(24, 2023) # uncomment at end, once correct on test input
# also consider aoc_input_data_frame() or aoc_input_matrix(), with view = TRUE

browseURL("https://adventofcode.com/2023/day/24")
# use datapasta addin to copy in test input from the website
# triple-click in test input box in the puzzle to select, 
# then choose appropriate paste format from addin
# comment out once ready to run on full input

input <- c("19, 13, 30 @ -2,  1, -2", "18, 19, 22 @ -1, -1, -2", "20, 25, 34 @ -2, -2, -4", "12, 31, 28 @ -1, -2, -1", "20, 19, 15 @  1, -5, -3")
input

# Part 1 ---------------------------------------------------------------------

# First, let's get the maths right.
# Can get equation for line with y = m*x + (y1 − m*x1) 
# i.e. b = (y1 − m*x1) 
# given two lines, we solve m1 * x + b1 = m2 * x + b2,
# solve for x gives (b2 - b1)/(m1 - m2), 
# then plug back into equation of one of the lines for y point.

# A: (19, 13) with velocity (-2, 1) 
m1 <-  1/-2 
b1 <-  (13 - -0.5 * 19)
# B: (18, 19) with velocity (-1, -1) 
m2 <-  -1/-1 
b2 <-  (19 - 1*18) 

x <- (b2 - b1)/(m1 - m2)
y <- m1 * x + b1
y

i1 <- input[1]
i1 |> extract_numbers()

# path is one line of the original input
get_line <- function(path) {
	nums <- aochelpers::extract_numbers(path)
	
	px <- nums[1]
	py <- nums[2]
	vx <- nums[4]
	vy <- nums[5]
	m <- vy/vx
	b <- py - m * px
	
	return(list(px = px, py = py, m = m, b = b, vx = vx, vy = vy))
}

get_line(input[2])

both_in_range <- function(x, y, min = 7, max = 27) {
	ifelse(x >= min && x <= max && y >= min && y <= max,
				 TRUE,
				 FALSE)
} 

both_in_range(8, 20)
both_in_range(4, 20)
both_in_range(8, 30)

# Need to rule out crossing in the past,
# as for i1 and i5 for hailstone A
# as for i2 and i5 for both hailstones

# paths_intersect(input[1], input[5]) # 21.444, 11.777
# "19, 13, 30 @ -2,  1, -2"
# "20, 19, 15 @  1, -5, -3"

# paths_intersect(input[2], input[5]) # 19.666, 20.666
# "18, 19, 22 @ -1, -1, -2"
# "20, 19, 15 @  1, -5, -3"

paths_intersect <- function(path1, 
														path2, 
														min = 200000000000000, 
														max = 400000000000000) {
	A <- get_line(path1)
	B <- get_line(path2)
	
	# parallel lines won't intersect
	if (A$m == B$m) {
		# print("lines are parallel")
		return(FALSE)
	}
	
	# point of intersection
	x <- (B$b - A$b)/(A$m - B$m)
	y <- A$m * x + A$b
	
	# check if in past
	if (x > A$px && A$vx < 0 || x < A$px && A$vx > 0) {
		#print("intersect in past for A")
		return(FALSE)
	}
	
	if (x > B$px && B$vx < 0 || x < B$px && B$vx > 0) {
		#print("intersect in past for B")
		return(FALSE)
	}
	
	both_in_range(x, y, min = min, max = max)
}

# parallel
paths_intersect(input[2], input[3])

# intersect in range
paths_intersect(input[1], input[2])

# intersect out of range
paths_intersect(input[1], input[4])

# intersect in past for A
paths_intersect(input[1], input[5])

# intersect in past for both
paths_intersect(input[2], input[5])

# check all pairs
all_pairs <- expand.grid(input, input, stringsAsFactors = FALSE)
unique_pairs <- all_pairs[all_pairs$Var1 < all_pairs$Var2, ]
unique_pairs 

mapply(paths_intersect, unique_pairs$Var1, unique_pairs$Var2) |> 
	sum()

# now on full input 
input <- aoc_input_vector(24, 2023) 
all_pairs <- expand.grid(input, input, stringsAsFactors = FALSE)
unique_pairs <- all_pairs[all_pairs$Var1 < all_pairs$Var2, ]

mapply(paths_intersect, unique_pairs$Var1, unique_pairs$Var2) |> 
	sum()

mapply(paths_intersect, unique_pairs$Var1, unique_pairs$Var2) |> 
	sum() |> 
	system.time()
# 3.39 secs

# Part 2 ---------------------------------------------------------------------
