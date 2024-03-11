# modify_tree example
# https://purrr.tidyverse.org/reference/modify_tree.html

x <- list(list(a = 2:1, c = list(b1 = 2), b = list(c2 = 3, c1 = 4)))
x |> str()
x

# Transform each leaf
x |> modify_tree(leaf = \(x) x + 100) |>  str()

# Recursively sort the nodes
sort_named <- function(x) {
	nms <- names(x)
	if (!is.null(nms)) {
		x[order(nms)]
	} else {
		x
	}
}
x |> modify_tree(post = sort_named) |> str()

# recursive sum
sum_list <- function(lst) {
	unlist(lst) |> sum()
}

x |> modify_depth(2, sum_list)
x |> modify_depth(1, sum_list)

y <- list(1:4, list(5:6, 7:8), 9:10)
reduce(y, sum)


z <- list(1:4, 5:6, 7:8, 9:10)
accumulate(z, sum)
reduce(z, sum)
