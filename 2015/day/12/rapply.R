x <- list(1,list(2,3),4,list(5,list(6,7)))
str(x)

sum_list <- function(lst) {
	unlist(lst) |> sum()
}

rapply(x,function(x){x^2}, class = "numeric")

x <- list(1:4, list(5:6, 7:8), 9:10)
str(x)
rapply(x, sum, how = "replace", classes = "integer") 
rapply(x, sum, how = "unlist", classes = "integer") 
rapply(x, sum, how = "list", classes = "integer")
