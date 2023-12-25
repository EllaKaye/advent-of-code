library(aochelpers)
input <- aoc_input_vector(25, 2023) # uncomment at end, once correct on test input
# also consider aoc_input_data_frame() or aoc_input_matrix(), with view = TRUE

browseURL("https://adventofcode.com/2023/day/25")
# use datapasta addin to copy in test input from the website
# triple-click in test input box in the puzzle to select, 
# then choose appropriate paste format from addin
# comment out once ready to run on full input

input <- c("jqt: rhn xhk nvd", "rsh: frs pzl lsr", "xhk: hfx", "cmg: qnr nvd lhk bvb", "rhn: xhk bvb hfx", "bvb: xhk hfx", "pzl: lsr hfx nvd", "qnr: nvd", "ntq: jqt hfx bvb xhk", "nvd: lhk", "lsr: lhk", "rzs: qnr cmg lsr rsh", "frs: qnr lhk lsr")



# Part 1 ---------------------------------------------------------------------

library(tidyverse)
library(igraph)

input_tbl <- input |> 
	as_tibble() |> 
	separate_wider_delim(value, ":", names = c("from", "to")) |> 
	separate_longer_delim(to, " ") |> 
	filter(to != "")

edgelist <- as.matrix(input_tbl)
edgelist

comp_graph <- graph_from_edgelist(edgelist, directed = FALSE)
cuts <- min_cut(comp_graph, value.only = FALSE)
length(cuts$partition1) * length(cuts$partition2)

# Part 2 ---------------------------------------------------------------------
