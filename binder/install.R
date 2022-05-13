# install.packages(
#   c(
#     "chron",
#     "config",
#     "crul",
#     "dplyr",
#     "data.table",
#     "DT",
#     "ggplot2",
#     "googlesheets4",
#     "glue",
#     "golem",
#     "highcharter",
#     "jsonlite",
#     "knitr",
#     "leaflet",
#     "lubridate",
#     "magrittr",
#     "markdown",
#     "mongolite",
#     "NPS",
#     "nycflights13",
#     "openxlsx",
#     "pkgload",
#     "qdapRegex",
#     "RColorBrewer",
#     "readxl",
#     "reshape2",
#     "rgdal",
#     "rlang",
#     "rmarkdown",
#     "scales",
#     "shiny",
#     "shinycssloaders",
#     "shinyWidgets",
#     "skimr",
#     "stringr",
#     "textdata",
#     "tidyr",
#     "tidytext",
#     "tidyverse",
#     "tm",
#     "wordcloud2"
#   )
# )

install.packages(
  c(
    "dplyr",
    "tidyr",
    "stringr",
    "openxlsx"
  )
)

# Use devtools to install packages not on CRAN, e.g. from Github
install.packages("devtools")
devtools::install_github("nhsbsa-data-analytics/nhsbsaR")
