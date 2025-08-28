# Clear environment -----------------------------------------------------------
rm(list = ls())

# install packages-------------------------------------------------------------
install.packages("dplyr")
install.packages("lubridate")
install.packages("tidyverse")
install.packages("readr")
install.packages("jsonlite")
install.packages("httr")

# Load libraries --------------------------------------------------------------
library(dplyr)
library(lubridate)
library(tidyverse)
library(readr)
library(jsonlite)
library(httr)

# -----------------------------------------------------------------------------
# Note: This code was heavily inspired by "open-data-portal-api.R" found at
# https://github.com/nhsbsa-data-analytics/open-data-portal-api
# Full credit and thanks to the developers of this resource.
# ----------------------------------------------------------------------------


# 1. Prepare the API path ------------------------------------------------------
base_endpoint <- "https://opendata.nhsbsa.net/api/3/action/"
package_list_method <- "package_list"     # List of data-sets in the portal
package_show_method <- "package_show?id=" # List all resources of a data-set
action_method <- "datastore_search_sql?"  # SQL action method


# 2. Find the name of the data set and the resource you're interested in -------
#------------------------------------------------------------------------------

# Send API call to get list of data-sets
datasets_response <- jsonlite::fromJSON(paste0(
  base_endpoint,
  package_list_method
))

# Look at the data-sets currently available and find data set of interest
datasets_avail <- datasets_response$result
datasets_avail

# explore
length(datasets_avail) #very long because of FOI requests
head(datasets_avail,10)
head(datasets_avail,30)

# look at non-FOI dataset list 
non_foi_datasets <- grep("^foi", datasets_avail, ignore.case = TRUE, invert = TRUE, value = TRUE)
non_foi_datasets

# e.g. look for secondary care datasets 
secondary_matches <- grep("secondary", datasets_avail, ignore.case = TRUE, value = TRUE)
secondary_matches

# Define ID of data set of interest accordingly - We'll look at secondary care data
dataset_id <- "finalised-secondary-care-medicines-data-scmd-with-indicative-price"


# Send API call to get list of resources
resources_response <- jsonlite::fromJSON(paste0(
  base_endpoint,
  package_show_method,
  dataset_id
))

# Look at resource names available and find resources of interest
resource_names <- resources_response$result$resources$bq_table_name
resource_names

# Choose a resource
resource_name <- "SCMD_FINAL_202501"


# 3. Prepare and make API call  -----------------------------------------------
# ------------------------------------------------------------------------------


# Build SQL query 
# - can filter here directly, e.g. here I've filtered to include just Paracetamol 500mg capsules
api_query <- paste0(
  "
  SELECT
      *
  FROM `", resource_name, "`
  WHERE VMP_PRODUCT_NAME = 'Paracetamol 500mg capsules'
  "
)

# Build API call accordingly
api_call <- paste0(
  base_endpoint,
  action_method,
  "resource_id=",
  resource_name, 
  "&",
  "sql=",
  URLencode(api_query) # Encode spaces in the url
)


# Grab the response JSON as a list
api_response <- jsonlite::fromJSON(api_call)


# For smaller data sets, get data frame directly from API call
response_df <- api_response$result$result$records
view(response_df)


# For larger data sets, need a different approach


# ... e.g. if we remove the Paracetamol filter:


api_query <- paste0(
  "
  SELECT
      *
  FROM `", resource_name, "`
  "
)

# Build API call as usual
api_call <- paste0(
  base_endpoint,
  action_method,
  "resource_id=",
  resource_name, 
  "&",
  "sql=",
  URLencode(api_query) # Encode spaces in the url
)


# Grab the response JSON as usual
api_response <- jsonlite::fromJSON(api_call)


# Gathering the data as before doesn't work (try this and see!)
response_df <- api_response$result$result$records
view(response_df)
response_df

# This is because the API call returns a URL to a data download instead, so have to treat this differently

# Extract the URL
data_url <- api_response$result$gc_urls$url

# Download and read the compressed CSV file

#   create temporary file in prep for download
temp_file <- tempfile(fileext = ".csv.gz")  
#   add data to temporary file
GET(data_url, write_disk(temp_file, overwrite = TRUE))
#   read the file
response_df <- read_csv(temp_file, show_col_types = FALSE)
view(response_df) #takes a few seconds to load


# Note - for an even bigger query, a list of URLs can be returned


# We often want to look at lots of dates:
resource_names
