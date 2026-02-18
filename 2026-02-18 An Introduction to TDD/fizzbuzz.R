#' Transform a number using FizzBuzz logic
#'
#' The output will be a string based on the FizzBuzz logic:
#'  - number divisible by 3, but not 5: "Fizz"
#'  - number divisible by 5, but not 3: "Buzz"
#'  - number divisible by both 3 and 5: "FizzBuzz"
#'  - otherwise: number in string format
#'
#' @param number length 1 numeric vector
#'
#' @returns character
#' 
#' @export
#'
#' @examples
#' fizzbuzz(0) # NULL
#' fizzbuzz(2) # "2"
#' fizzbuzz(9) # "Fizz"
#' fizzbuzz(10) # "Buzz"
#' fizzbuzz(30) # "FizzBuzz"
fizzbuzz <- function(number) {
  stopifnot(
    "Input must be numeric" = is.numeric(number),
    "Input must be length 1" = length(number) == 1,
    "Input must be positive" = number > 0,
    "Input must be a whole number" = number %% 1 == 0
  )

  is_divisible_by_3 <- (number %% 3) == 0
  is_divisible_by_5 <- (number %% 5) == 0
  
  if (is_divisible_by_3 & is_divisible_by_5) return("FizzBuzz")
  if (is_divisible_by_3) return("Fizz")
  if (is_divisible_by_5) return("Buzz")
  
  as.character(number)
}


#' Get list of numbers up to n, transformed using FizzBuzz logic
#'
#' The output will be a list of strings based on the FizzBuzz logic, for numbers 1 up to N:
#'  - number divisible by 3, but not 5: "Fizz"
#'  - number divisible by 5, but not 3: "Buzz"
#'  - number divisible by both 3 and 5: "FizzBuzz"
#'  - otherwise: number in string format
#'
#' @param number length 1 numeric vector
#'
#' @returns character
#' 
#' @export
#'
#' @examples
#' fizzbuzzer(2) # list("1", 2")
#' fizzbuzz(3) # list("1", "2", Fizz")
#' fizzbuzz(5) # list("1", "2", Fizz", "4", "Buzz")
#' fizzbuzz(15) # list("1", "2", Fizz", "4", "Buzz", ..., "FizzBuzz")
fizzbuzzer <- function(number) {
  lapply(seq_len(number), fizzbuzz)
}
