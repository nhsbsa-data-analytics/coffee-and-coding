#' Is point `(x,y)` on an axis of the plane?
#'
#' The point `(x,y)` lies on an axis if at least one of the coordinates is zero.
#'
#' @param x Numeric
#' @param y Numeric
#'
#' @return `TRUE` or `FALSE`, according to whether `(x,y)` lies on an axis
#' @export
#'
#' @examples
#' on_axes(0, 0) # TRUE, this is the origin
#' on_axes(1, 0) # TRUE, this is on x-axis
#' on_axes(0, 1) # TRUE, this is on y-axis
#' on_axes(1, 1) # FALSE
on_axes <- function(x, y) {
  any(c(x,y) == 0) # If either x or y is 0, TRUE
}
