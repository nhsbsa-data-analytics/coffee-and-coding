test_that("absolute works with +ve number", {
  expect_equal(absolute(10), 10)
})

test_that("absolute works with -ve number", {
  expect_equal(absolute(-10), 10)
})

test_that("absolute works with 0", {
  expect_equal(absolute(0), 0)
})

test_that("absolute works with NA", {
  expect_equal(absolute(NA), NA_real_)
})

test_that("absolute works with NULL", {
  expect_equal(absolute(NULL), numeric(0))
})

test_that("absolute fails with character", {
  expect_error(absolute("10"), "non-numeric argument to binary operator")
})
