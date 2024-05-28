#' Get quadrant of `(x,y)` coordinates
#' 
#' The quadrant definitions are those found in
#'  [Wikipedia](https://en.wikipedia.org/wiki/Quadrant_(plane_geometry))
#'
#' @param x Numeric
#' @param y Numeric
#'
#' @return Quadrant specified in Roman numerals, or message that point is not in
#'  any quadrant.
#' @export
#'
#' @examples
#' quadrant(1, 2)  # "I"
#' quadrant(-1, 2) # "II"
#' quadrant(-1,-2) # "III"
#' quadrant(1, -2) # "IV"
#' quadrant(1, 0)   # "No quadrant"
quadrant <- function(x, y) {
  if (on_axes(x, y)) return ("No quadrant")
  
  signs <- sign(c(x, y))                        # maps x, y to -1, 0 or 1
  signs <- sub("1", "+", sub("-1", "-", signs)) # replaces 1, -1 with +, -
  signs <- paste0(signs, collapse = "")         # get a single string of x, y signs
  
  switch (signs,
          `++` = "I",
          `-+` = "II",
          `--` = "III",
          `+-` = "IV"
  )
}
