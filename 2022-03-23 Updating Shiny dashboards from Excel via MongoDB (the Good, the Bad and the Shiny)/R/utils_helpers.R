#' Custom NHSBSA highcharter theme
#'
#' Based on the nhsbsaR highcharter theme, since it returns a list we can edit
#' it to the specific theme for this shiny app.
#'
#' @param hc The highcharter object to add theme to.
#' @param palette Which colour palette to use from the `nhsbsaR` package.
#' @param stack Stack option for highcharter.
#'
#' @return A highcharter object with theme applied.
theme_nhsbsa <- function(hc, palette = NA, stack = "normal") {

  # Load theme from nhsbsaR package
  theme_nhsbsa_hc <- nhsbsaR::theme_nhsbsa_hc(family = "Frutiger W01")

  # Add the plot options
  # Begin Exclude Linting
  theme_nhsbsa_hc$plotOptions <- list(
    series = list(stacking = stack, borderWidth = 0),
    bar = list(groupPadding = 0.1)
  )

  # Add the palettes
  theme_nhsbsa_hc$colors <- nhsbsaR::palette_nhsbsa(palette = palette)
  theme_nhsbsa_hc$colAxis <- list(
    min = 0,
    minColor = nhsbsaR::palette_nhsbsa(palette = "gradient")[1],
    maxColor = nhsbsaR::palette_nhsbsa(palette = "gradient")[2]
  )

  # Add the theme to the chart and then remove the credits afterwards (currently
  # does not work to do this within the theme)
  hc %>%
    highcharter::hc_add_theme(hc_thm = theme_nhsbsa_hc) %>%
    highcharter::hc_colors(colors = nhsbsaR::palette_nhsbsa(palette = palette))
  # End Exclude Linting
}


#' Evaluate each line of plain text file
#'
#' Reads a plain text file line by line, evaluating each line. Useful for
#' creating variables dynamically, e.g. reading in parameters.
#'
#' @param filepath Filepath as a String.
#'
#' @return Nothing
#'
#' @examples
#' \dontrun{
#' filepath <- tempfile()
#' writeLines(
#'   text = "LEFT = \"right\"",
#'   con = filepath
#' )
#' eval_lines(filepath)
#' print(LEFT)
#' unlink(filepath) # delete temporary file
#' rm(left) # remove example variable
#' }
eval_lines <- function(filepath) {
  con <- file(filepath, open = "r")
  on.exit(close(con))

  while (length(line <- readLines(con, n = 1, warn = FALSE)) > 0) {
    eval(parse(text = line), envir = .GlobalEnv)
  }
}

nth_preceding_month <- function(months, n) {
  sort(unique(months), decreasing = TRUE)[n + 1]
}
