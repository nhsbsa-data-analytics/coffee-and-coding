test_that("Sign of the product", {
  expect_equal(sign_of_product(1, -1), "Negative")
  expect_equal(sign_of_product(-1, -1), "Positive")
})
