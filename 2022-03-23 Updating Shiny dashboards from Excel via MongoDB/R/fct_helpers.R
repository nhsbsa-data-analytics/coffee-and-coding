#' Retrieve data from MongoDB
#'
#' @description  Retrieve all data from a mongodb collection. Optionally,
#'   replace the collection data first.
#'
#' @param collection Name of the collection.
#' @param db Name of the database the collection is in.
#' @param connection_string Address of the mongodb server in mongo connection
#'   string [URI
#'   format](https://docs.mongodb.com/manual/reference/connection-string/).
#' @param replace_with Default is NULL. If passed, must be a dataframe, named
#'   list (for single record) or character vector with json strings (one string
#'   for each row).
#'
#' @return Returns all data in the given collection as a dataframe.
#'
#' @examples
#' \dontrun{
#' # Get the data in my_collection (in the my_db database)
#' get_mongo_collection(
#'   "my_collection", "my_db",
#'   connection_string = glue::glue(
#'     "mongodb+srv://{MONGO_USER}:{MONGO_PASS}@{MONGO_HOST}",
#'     "/?tls=true&retryWrites=true&w=majority"
#'   )
#' )
#'
#' # Replace the data in my_collection (in the my_db database) with the data in
#' # my_dataframe, then get that data
#' get_mongo_collection(
#'   "my_collection", "my_db",
#'   connection_string = glue::glue(
#'     "mongodb+srv://{MONGO_USER}:{MONGO_PASS}@{MONGO_HOST}",
#'     "/?tls=true&retryWrites=true&w=majority"
#'   ),
#'   replace_with = my_dataframe
#' )
#' }
get_mongo_collection <- function(collection, db,
                                 connection_string,
                                 replace_with = NULL) {
  conn <- mongolite::mongo(
    collection = collection,
    db = db,
    url = connection_string,
    options = mongolite::ssl_options(weak_cert_validation = TRUE)
  )
  on.exit(rm(conn) & gc())

  if (!is.null(replace_with)) {
    if (conn$count() > 0) conn$drop()
    conn$insert(replace_with)
  }

  conn$find()
}


#' Load data from mongoDB
#'
#' @description Attempts to read data from specified mongoDB collection. Once
#' read, the raw data is cleaned and prepared. If an error occurs in either of
#' these 2 steps, data is read from an .rda file in the data folder - this
#' contains the last successfully read data from the mongoDB collection.
#'
#' @param data Either "data" or "targets"
#' @param r A reactiveValues object
#'
#' @return Nothing - a new child of r is created to hold the data.
#'
#' @examples
#' \dontrun{
#' r <- reactiveValues()
#'
#' load_data(r, "data")
#' load_data(r, "targets")
#' }
load_data <- function(r, data) {
  tryCatch(
    r[[glue("fic_{data}")]] <- get(glue("{data}_prep"))(
      get_mongo_collection(
        glue("FIC_{data}"), "FIC",
        connection_string = glue(
          "mongodb+srv://{MONGO_USER}:{MONGO_PASS}@{MONGO_HOST}",
          "/?tls=true&retryWrites=true&w=majority"
        )
      )
    ),
    error = function(e) {
      print(
        glue(
          "Error reading or preparing {data} from mongoDB: {e}",
          "Using last read data"
        )
      )
      r[[glue("fic_{data}")]] <- switch(data,
        "data" = fic::data,
        "targets" = fic::targets
      )
    }
  )
}


#' Group related content in dashboard
#'
#' @param title Title string
#' @param ... Content elements
#'
#' @return HTML defining the content
#'
#' @examples
#' \dontrun{
#' content_box(
#'   "I have content!",
#'   shiny::selectInput("input", "Choose", c("Option 1", "Option 2")),
#'   shiny::uiOutput("output")
#' )
#' }
content_box <- function(title, ...) {
  div(
    class = "ui card",
    style = "margin:auto; width:100%;",
    div(
      class = "extra content",
      style = "background-color: #E8EDEE;",
      div(
        class = "left aligned description",
        style = "font-size:16px; color: black;",
        HTML(glue("<b>{title}</b>"))
      )
    ),
    div(
      class = "content",
      div(
        ...
      )
    )
  )
}


#' Calculate whether NPS score has significantly changed between 2 samples.
#'
#' @description A margin of error is calculated for each sample, from the number of
#' promoters, neutrals (i.e. passives) and detractors. The standard error of
#' their difference is estimated using the Pythagorean formula, and the absolute
#' difference of the two samples is compared to this multiplied by the critical
#' value (aka z*-value).
#'
#' The return value is in (-1, 0, +1), according to whether a significant decrease
#' is found, no significant change, or a significant increase, respectively. If
#' the total for a sample is 0, then 0 is returned.
#'
#' Formula is based on the one found in this [blog post]
#' (https://www.genroe.com/blog/how-to-calculate-margin-of-error-and-other-stats-
#' for-nps/5994).
#'
#' @param p_0 Number of Promoters in latest sample
#' @param n_0 Number of Neutrals in latest sample
#' @param d_0 Number of Detractors in latest sample
#' @param p_1 Number of Promoters in oldest sample
#' @param n_1 Number of Neutrals in oldest sample
#' @param d_1 Number of Detractors in oldest sample
#' @param z_val Critical value multiplier; 1.96 by default for a 95% confidence
#' interval. See [this table]
#' (http://www.ltcconline.net/greenl/courses/201/estimation/smallConfLevelTable.htm)
#' for further values of z_val for common confidence intervals.
#'
#' @return A value in (-1, 0, +1); see notes above.
#'
#' @examples
#' # Test with a 99% confidence interval
#' \dontrun{
#' nps_moe_test(123, 456, 789, 321, 654, 987, z_val = 2.58)
#' }
nps_moe_test <- function(p_0, n_0, d_0,
                         p_1, n_1, d_1,
                         z_val = 1.96) {
  if (NA %in% c(p_0, n_0, d_0, p_1, n_1, d_1)) {
    return(0)
  }

  t_0 <- p_0 + n_0 + d_0
  if (t_0 == 0) {
    return(0)
  }
  nps_0 <- (p_0 - d_0) / t_0
  t_1 <- p_1 + n_1 + d_1
  if (t_1 == 0) {
    return(0)
  }
  nps_1 <- (p_1 - d_1) / t_1

  var_0 <- ((1 - nps_0)^2 * p_0 + nps_0^2 * n_0 + (-1 - nps_0)^2 * d_0) / t_0
  var_1 <- ((1 - nps_1)^2 * p_1 + nps_1^2 * n_1 + (-1 - nps_1)^2 * d_1) / t_1

  se_0 <- sqrt(var_0 / t_0)
  se_1 <- sqrt(var_1 / t_1)

  if (abs(nps_0 - nps_1) > z_val * sqrt(se_0^2 + se_1^2)) {
    if (nps_0 > nps_1) {
      return(1)
    }
    return(-1)
  }

  0
}
