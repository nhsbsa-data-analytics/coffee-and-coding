

my_demo_fun <- function(playA = "Ottilie", playB = "Mordechai"){

# Description:  Two player rock-paper-scissors game  
  
  res0 <- sample(c(1:3), 2, replace = TRUE)
  res <- c("rock", "paper", "scissors")[res0]
  res2 = res0[1] - res0[2]
  
  cat("\n", playA, ": ", res[1], "\n", playB, ": ", res[2], "\n")
  
  if(res2 == 0) {cat("\n", "Neither", playA, "or", playB, "has won.")}  
    else {
      if (res2 %in% c(-1, 2)) {cat("\n", playB, "has won.", "\n", "\n")}  
        else {cat("\n", playA, "has won.", "\n", "\n")}} 
  
}

