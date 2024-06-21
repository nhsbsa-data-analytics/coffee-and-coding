library(plumber)
library(jsonlite)
library(data.table)
library(plotly)
library(htmlwidgets)

# Define base endpoint and SQL action method
base_endpoint <- "https://opendata.nhsbsa.net/api/3/action/"
sql_action_method <- "datastore_search_sql?"

#* @apiTitle Open Data Portal antibiotic prescription data API (BNF Chapter 5.1)
#* @apiDescription API to fetch and visualise antibiotic drug prescription data by ICB for a specified month.

#* Fetch and plot antibiotic prescription data
#* @param resource_id The numerical part of the resource ID of the dataset to fetch
#* @get /antibiotic_data
function(resource_id, res) {
  # Prepend "EPD_" to the resource_id
  full_resource_id <- paste0("EPD_", resource_id)
  
  # Build our query
  tmp_query <- paste0(
    "
    SELECT
      YEAR_MONTH,
      REGIONAL_OFFICE_NAME,
      ICB_NAME,
      BNF_CHAPTER_PLUS_CODE,
      COUNT(ITEMS) as ITEM_COUNT
    FROM `", full_resource_id, "`
    WHERE
      BNF_CHEMICAL_SUBSTANCE LIKE '0501%'
    AND ICB_NAME != 'UNIDENTIFIED'
    GROUP BY
      YEAR_MONTH,
      REGIONAL_OFFICE_NAME,
      BNF_CHAPTER_PLUS_CODE,
      ICB_NAME
    "
  )
  
  # Build temporary API call
  tmp_api_call <- paste0(
    base_endpoint,
    sql_action_method,
    "resource_id=",
    full_resource_id,
    "&",
    "sql=",
    URLencode(tmp_query) # Encode spaces in the URL
  )
  
  # Grab the response JSON as a temporary list
  tmp_response <- fromJSON(tmp_api_call)
  
  # Extract records in the response to a temporary dataframe
  antibiotic_icb_df <- as.data.table(tmp_response$result$result$records)
  
  # Create the Plotly bar chart
  fig <- plot_ly(data = antibiotic_icb_df, 
                 x = ~ICB_NAME, 
                 y = ~ITEM_COUNT, 
                 type = 'bar', 
                 text = ~paste(REGIONAL_OFFICE_NAME, "<br>Items:", ITEM_COUNT),
                 marker = list(color = 'rgba(50, 171, 96, 0.6)',
                               line = list(color = 'rgba(50, 171, 96, 1.0)',
                                           width = 1.5))) |> 
    layout(title = "ICBs with item counts for antibacterial drugs",
           xaxis = list(title = "ICB", tickangle = -45),
           yaxis = list(title = "Items"),
           margin = list(b = 150),
           hovermode = "closest")
  
  # Save the Plotly chart as an HTML file
  chart_file <- tempfile(fileext = ".html")
  saveWidget(fig, chart_file, selfcontained = TRUE)
  chart_html <- readLines(chart_file, warn = FALSE)
  
  # Create the HTML content
  html_content <- paste0(
    "<html><head><title>Antibiotic prescription data extracted from ODP</title></head><body>",
    paste(chart_html, collapse = "\n"),
    "</body></html>"
  )
  
  # Return the HTML content as the response
  res$setHeader("Content-Type", "text/html")
  res$body <- html_content
  res
}
