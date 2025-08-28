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

# # Send API call to get list of data-sets
# datasets_response <- jsonlite::fromJSON(paste0(
#   base_endpoint,
#   package_list_method
# ))
# 
# # Look at the data-sets currently available and find data set of interest
# datasets_avail <- datasets_response$result
# head(datasets_avail,20)

# Define ID of data set of interest accordingly
dataset_id <- "finalised-secondary-care-medicines-data-scmd-with-indicative-price"


# # Send API call to get list of resources
# resources_response <- jsonlite::fromJSON(paste0(
#   base_endpoint,
#   package_show_method,
#   dataset_id
# ))
# 
# # Look at resource names available and find resources of interest
# resource_names <- resources_response$result$resources$bq_table_name

# Define prefix of resources accordingly
resource_prefix <- "SCMD_FINAL_"

# 3. Set date range of interest and generate resource names accordingly--------
# -----------------------------------------------------------------------------

start_date <- as.Date("2023-04-01")
end_date <- as.Date("2024-03-31")
date_seq <- seq(from = start_date, to = end_date, by = "month")

# Format as SCMD_PROVISIONAL_YYYYMM
resource_name_list <- paste0(resource_prefix, format(date_seq, "%Y%m"))


# 4. Build data frame using API calls -----------------------------------------
# ------------------------------------------------------------------------------

# Create empty data frame
master_df <- data.frame()

# Loop through resource_name_list and make call to API to extract data for each
for(resource_name in resource_name_list) {
  
  #resource_name = resource_name_list[1]  #un comment for testing
  
  # Build temporary SQL query
  tmp_query <- paste0(
    "
  SELECT
      *
  FROM `",
    resource_name, "`
  "
  )
  
  
  # Build temporary API call
  tmp_api_call <- paste0(
    base_endpoint,
    action_method,
    "resource_id=",
    resource_name, 
    "&",
    "sql=",
    URLencode(tmp_query) # Encode spaces in the url
  )
  
  # Grab the response JSON as a temporary list
  tmp_response <- jsonlite::fromJSON(tmp_api_call)
  
  # For smaller data sets, get data frame directly from API call
  tmp_df <- tmp_response$result$result$records
  
  # For larger data sets, API call returns a URL, or vector of URLs, from 
  # which to get data...
  
  # ...in which case:
  if ( is.null(tmp_df) ){
    # Extract the download URLs
    download_urls <- tmp_response$result$gc_urls$url
    
    # Begin with an empty data frame
    tmp_df <- data.frame()
    
    # for each URL...
    for(url_item in download_urls) {
      
      # ...Download and read the compressed CSV file
      temp_file <- tempfile(fileext = ".csv.gz")
      GET(url_item, write_disk(temp_file, overwrite = TRUE))
      url_df <- read_csv(temp_file, show_col_types = FALSE)
      
      # add data to the data frame
      tmp_df <- bind_rows(tmp_df, url_df)
    }
    
  }
  
  # keep an eye on progress
  print( c(resource_name, length(tmp_df),nrow(tmp_df)) ) 
  
  # Bind the temporary data to the main data frame
  master_df <- bind_rows(master_df, tmp_df)
}

# 5. Save master table if necessary --------------------------------------------
# !!! WARNING !!! master_df is big, so download with caution
# ------------------------------------------------------------------------------

#write.csv(master_df, paste0(resource_prefix,start_date,"--",end_date,".csv"), row.names = FALSE)


