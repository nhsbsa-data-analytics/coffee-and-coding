library(testthat)
source("fizzbuzz.R")

test_results <- test_dir("tests")
summary_view <- as.data.frame(test_results)

cols_to_keep <- c(
  "file",
  "test",
  "nb",
  "failed",
  "skipped",
  "error",
  "warning",
  "passed"
)

print(summary_view[, cols_to_keep])
