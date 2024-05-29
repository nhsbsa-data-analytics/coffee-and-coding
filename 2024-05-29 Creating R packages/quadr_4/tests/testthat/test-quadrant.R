test_that("correct quadrants are given", {
  expect_equal(quadrant( 1,  2), "I")
  expect_equal(quadrant(-1,  2), "II")
  expect_equal(quadrant(-1, -2), "III")
  expect_equal(quadrant( 1, -2), "IV")
  expect_equal(quadrant( 0,  1), "No quadrant")
  expect_equal(quadrant( 1,  0), "No quadrant")
  expect_equal(quadrant( 0,  0), "No quadrant")
})
