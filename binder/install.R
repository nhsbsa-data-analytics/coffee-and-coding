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
#     "kableExtra",
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
#     "wordcloud2",
#     "reticulate",
#     "mlbench"
#    )
#  )

# install.packages(
#   c(
#     "tidyverse",
#     "kableExtra",
#     "knitr"
#   )
# )

install.packages(
  c(
    "dplyr",
    "dbplyr",
    "DBI",
    "nycflights13",
    "RSQLite",
    "knitr",
    "rmarkdown",
    "lubridate"
  )
)

# Use devtools to install packages not on CRAN, e.g. from Github
install.packages("devtools")
devtools::install_github("nhsbsa-data-analytics/nhsbsaR")
devtools::install_github("nhsbsa-data-analytics/personMatchR")
