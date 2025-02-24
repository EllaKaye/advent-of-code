# I have 4 people that I want to seat around a table
# I can create permulations of 1:4, but I want to remove the ones that are the same if I rotate the table
# I also want to remove the ones that are the same if I flip the table
# create a function that takes n as an input and returns a list of all the unique permutations,
# where the permutations are unique if they are the same if the table is rotated or flipped

# write a recursive function to create the factorial of n:
fact <- function(n) {
  if (n == 0) {
    return(1)
  } else {
    return(n * fact(n - 1))
  }
}

arrangements <- function(n) {
	
	# create a list of all the permutations
  perms <- permutations(n, n)
  # create a list to store the unique permutations
  unique_perms <- vector(fact(n)/(n * 2), mode = "list")
  # loop through the permutations
  for (i in 1:nrow(perms)) {
    # get the current permutation
    perm <- perms[i,]
    # check if the permutation is unique
    if (!is.unique(perm, unique_perms)) {
      # if it is unique, add it to the list of unique permutations
      unique_perms <- c(unique_perms, list(perm))
    }
  }
  # return the list of unique permutations
  return(unique_perms)
}

# write the is.unique function, which checks if the permuation is unique
is.unique <- function(perm, unique_perms) {
  # loop through the unique permutations
  for (i in 1:length(unique_perms)) {
    # get the current unique permutation
    unique_perm <- unique_perms[[i]]
    # check if the permutation is the same as the unique permutation
    if (identical(perm, unique_perm)) {
      # if it is the same, return TRUE
      return(TRUE)
    }
  }
  # if the permutation is not the same as any of the unique permutations, return FALSE
  return(FALSE)
}

arrangements(4)
