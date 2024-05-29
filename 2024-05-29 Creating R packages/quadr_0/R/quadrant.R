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
