test_that("Output is Fizz if divisible by 3, but not by 5", {
  input <- c(3, 6, 9)
  
  for (i in input) {
    expect_equal(fizzbuzz(i), "Fizz")
  }
})

test_that("Output is Buzz if divisible by 5, but not by 3", {
  input <- c(5, 10, 20)
  
  for (i in input) {
    expect_equal(fizzbuzz(i), "Buzz")
  }
})

test_that("Output is FizzBuzz if divisible by both 3 and 5", {
  input <- c(15, 30, 45)
  
  for (i in input) {
    expect_equal(fizzbuzz(i), "FizzBuzz")
  }
})

test_that("Output is number as string if divisible by neither 3 or 5", {
  input <- c(1, 2, 4)
  
  for (i in input) {
    expect_equal(fizzbuzz(i), as.character(i))
  }
})

test_that("Correct sequence is output as a list", {
  input <- c(0, 1, 3, 5, 15)
  expected <- list(
    list(),
    list("1"),
    list("1", "2", "Fizz"),
    list("1", "2", "Fizz", "4", "Buzz"),
    list(
      "1",    "2",    "Fizz", "4",    "Buzz",
      "Fizz", "7",    "8",    "Fizz", "Buzz",
      "11",   "Fizz", "13",   "14",   "FizzBuzz"
    )
  )
  
  for (idx in seq_along(input)) {
    expect_equal(fizzbuzzer(input[idx]), expected[[idx]])
  }
})

test_that("Errors when input is not numeric", {
  input <- c("foo", TRUE, list(list(15)))
  
  for (i in input) {
    expect_error(fizzbuzz(i), "Input must be numeric")
  }
})

test_that("Errors when input is not length 1 numeric vector", {
  # Vector is too long
  expect_error(fizzbuzz(c(1:5, 13:15)), "Input must be length 1")
  
  # Vector is too short (length 0)
  expect_error(fizzbuzz(numeric(0)), "Input must be length 1")
})

test_that("Errors when input is not positive number", {
  input <- c(-15, 0, -Inf)
  
  for (i in input) {
    expect_error(fizzbuzz(i), "Input must be positive")
  }
})

test_that("Errors when input is not whole number", {
  input <- c(0.1, 9.9, 99.9999)
  
  for (i in input) {
    expect_error(fizzbuzz(i), "Input must be a whole number")
  }
})
