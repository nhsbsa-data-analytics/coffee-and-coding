<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

# A single page `{shiny}` app to display some data from the Financial Information Collection Customer Satisfaction Survey.
Reads in data from a mongoDB collection. Includes a macro-enabled Excel workbook that can push data to a mongoDB collection at the push of a button (well 2 buttons...`CTRL+W`).

This R package is based on the [`{mongo2shiny}`](https://github.com/MarkMc1089/mongo2shiny) template, which is an extension of [`{nhsbsaShinyR}`](https://github.com/nhsbsa-data-analytics/nhsbsaShinyR) template developed by NHS Business Services Authority Data Analytics Learning Lab to use as a template for building NHSBSA branded R `{shiny}` dashboards.

## Usage
After initially cloning the repo, there will be no `data.rda` file in the `data` folder. This will cause an error in the case that the MongoDB connection is not available, as the fallback is to read the latest data. To ensure there is one, run the below code from the project root directory, making sure to source `R/data_prep.R` first.

```
library(dplyr)
library(readxl)
# Ensure you are in the project root folder
sample_data <- read_excel("data-raw/nhs_pensions_FIC_data.example.xlsm")
# You will need to source the data_prep.R file in the R folder
data_prep(sample_data)
```

To run the app, just open `app.R` and click Run app in RStudio.

## Features

The `{golem}` framework has been heavily used, and the code is modularised using
`{shiny}` modules. It has been built as a learning exercise to apply the patterns used in the excellent book [Engineering Production-Grade Shiny Apps](https://engineering-shiny.org/index.html)

At present everything is working well, and the R CMD check doesn't even have any notes! But, that is not much fun so I plan on breaking it soon by following the...

## Next Steps

1. Make use of (and possibly contribute to) the [`{nhsbsaR}`](https://github.com/nhsbsa-data-analytics/nhsbsaR) and [`{NHSRtheme}`](https://github.com/nhs-r-community/NHSRtheme) packages to make consistent NHS branding easily appliable.
2. Flesh out the mongoDB functionality - currently it allows only wholesale read or overwrite. Allowing updating only would make it faster to both read and write to the
database.
3.  Add persistent caching, facilitated by a flag read from the database indicating last update, so the app can instead use already saved data to prevent unnecessary reads.

## Structure

The package is structured as follows:

```
fic
├── .github/                              # Workflows for github actions
├── R/                                    # Most R code exists in here
│   ├── _disable_autoload.R               # Golem file
│   ├── app_config.R                      # Golem file
│   ├── app_server.R                      # Server component
│   ├── app_ui.R                          # UI component
|   ├── data_prep.R                       # data cleaning, preparation and saving
|   ├── data.R                            # data description
|   ├── fct_helpers.R                     # larger more focussed helper functions
|   ├── fic.R                             # package level docstrings and commonly
|   |                                     #   used external function imports
│   ├── golem_utils_*.R                   # Golem UI and server utils
│   ├── mod_*.R                           # Modules 
│   ├── run_app.R                         # Single exported function, to run app
|   ├── targets.R                         # targets description
│   ├── utils_helpers.R                   # smaller utility functions
├── data-raw/                             # Scripts and example data
│   ├── data.R                            # Creates data files in data folder
│   ├── nhs_pensions_FIC_*.example.xlsm   # Macro enabled Excel workbooks, used
|   |                                     #   to push data to mongoDB easily
├── data/                                 # Backup data, saved on every successful
|                                         #   read from the database
├── dev/                                  # Golem files
│   ├── 01_start.R                        # Golem file (use to set up golem)
│   ├── 02_dev.R                          # Golem file (use to develop package)
│   ├── 03_deploy.R                       # Golem file (use to deploy package)
│   └── run_dev.R                         # Golem file (use to test development)
├── inst/                                 # Installed files...
│   ├── app/                              # ... for the app...
│   │   └── www/                          # ... made available at runtime
│   │       ├── bsa_logo.svg              # NHS BSA logo
│   │       ├── favicon.png               # NHS webpage icon
│   │       └── stylesheet                # CSS to style the dashboard
│   └── golem-config.yml                  # Golem file
├── man/                                  # Documentation generated by roxygen2
├── .Rbuildignore                         # Golem file
├── .gitignore                            # Specify files to ignore, e.g. data
├── DESCRIPTION                           # Metadata of package
├── LICENSE.md                            # Apache
├── NAMESPACE                             # Automatically generated by roxygen2
├── README.md                             # Brief overview of the package
├── app.R                                 # Shiny app file
├── fic.Rproj                             # R Project file
```
