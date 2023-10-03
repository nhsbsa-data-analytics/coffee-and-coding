sign_of_product <- function(x, y) {
  if (x < 0) {
    if (y < 0) {
      return("Positive")
    } else {
      return("Negative")
    }
  } else {
    if (y < 0) {
      return("Negative")
    } else {
      return("Positive")
    }
  }
}
