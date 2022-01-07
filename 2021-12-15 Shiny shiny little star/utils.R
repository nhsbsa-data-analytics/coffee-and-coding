#' Evaluate each line of plain text file
#'
#' Reads a plain text file line by line, evaluating each line. Useful for
#' creating variables dynamically, e.g. reading in parameters.
#'
#' @param filepath Filepath as a String.
#'
#' @return Nothing
#' @export
#'
#' @examples
#' filepath <- tempfile()
#' writeLines(
#'   text = "LEFT = \"right\"",
#'   con = filepath
#' )
#' eval_lines(filepath)
#' print(LEFT)
#' unlink(filepath) # delete temporary file
#' rm(left) # remove example variable
eval_lines <- function(filepath) {
  con <- file(filepath, open = "r")
  on.exit(close(con))
  
  while (length(line <- readLines(con, n = 1, warn = FALSE)) > 0) {
    eval(parse(text = line), envir = .GlobalEnv)
  }
}