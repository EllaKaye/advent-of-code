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

paths_intersect <- function(path1, path2) {
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
	
	both_in_range(x, y)
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

get_coords <- function(stone) {
	nums <- extract_numbers(stone)
	p <- nums[1:3]
	v <- nums[4:6]
	return(list(p = p, v = v))
}

lapply(input, get_coords)

get_position <- function(stone, t) {
	nums <- extract_numbers(stone)
	p <- nums[1:3]
	v <- nums[4:6]
	p + v * t
}

get_position(input[1], 5)
get_position(input[2], 3)
get_position(input[3], 4)
get_position(input[4], 6)
get_position(input[5], 1)
# that's working

example_stone <- "24, 13, 10, -3, 1, 2"

lapply(1:6, \(x) get_position(example_stone, x))

s1 <- get_coords(input[1]) 
s2 <- get_coords(input[2]) 
s3 <- get_coords(input[3]) 

p1 <- s1$p # 19 13 30
p2 <- s2$p # 18 19 22
p3 <- s3$p # 20 25 34
v1 <- s1$v # -2  1 -2
v2 <- s2$v # -1 -1 -2
v3 <- s3$v # -2 -2 -4

# the p values correspond to the position of the hailstone
# the v values correspond to the velocity of the hailstone
# The positions indicate where the hailstones are right now (at time 0). 
# The velocities are constant and indicate exactly how far each hailstone will move in one nanosecond.
# For example, p = (20, 19, 15) moving with v = (1, -5, -3) will be at position (21, 14, 12) at t = 1. 
# Write a function that takes s1, s2 and s3 as input and returns s4, 
# where s4 is the position of the fourth hailstone at time t = 0,
# such that the line defined by s4 will intersect the lines defined by s1, s2 and s3 at some point in the future.
# we don't need s1, s2 and s3 to intersect, just the equation of the line that intersects all of them.
# hint: we may need to use solve()
# find_s4 <- function(s1, s2, s3) {
# 	p1 <- s1$p
# 	p2 <- s2$p
# 	p3 <- s3$p
# 	v1 <- s1$v
# 	v2 <- s2$v
# 	v3 <- s3$v
# 	
# 	# we need to find a point on the line defined by s4 that intersects all three lines
# 	# we can do this by solving the system of equations
# 	# p1 + v1 * t = p4 + v4 * t
# 	# p2 + v2 * t = p4 + v4 * t
# 	# p3 + v3 * t = p4 + v4 * t
# 	# we can solve this by subtracting p4 + v4 * t from both sides
# 	# p1 + v1 * t - p4 - v4 * t = 0
# 	# p2 + v2 * t - p4 - v4 * t = 0
# 	# p3 + v3 * t - p4 - v4 * t = 0
# 	# we can then solve this system of equations using solve()
# 	# b
# }	
# 
# find_s4(s1, s2, s3)
# 
# 
# Neither ChatGPT nor Copilot of much use with this.
# Try googling!
# The maths seems complicated:
# https://math.stackexchange.com/questions/607348/line-intersecting-three-or-four-given-lines
# https://www.quora.com/How-can-I-find-the-point-of-intersection-of-three-lines-simultaneously
# A solution in Python using z3-solver: https://github.com/nharrer/AdventOfCode/blob/main/2023/day24/solve_day24.py

input <- aoc_input_vector(24, 2023)
input[1]

