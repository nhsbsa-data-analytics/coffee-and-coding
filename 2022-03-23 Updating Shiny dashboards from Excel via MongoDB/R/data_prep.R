#' Prepare data
#'
#' Cleans and prepares raw data, saving it as an .rda file in data folder.
#'
#' @param raw_data A data-frame-like object
#'
#' @return Prepared data
#'
#' @noRd
#'
data_prep <- function(raw_data) {
  data <- raw_data %>%
    slice(-1) %>%
    select(
      -.data$ID.format,
      -.data$ID.completed,
      -.data$ID.start,
      -.data$ID.date,
      -.data$ID.end,
      -.data$ID.time,
      -.data$ID.name
    ) %>%
    rename(
      c(
        "ID.date" = "ID.endDate",
        "NetEasy" = "NetEasyScore",
        "Overall_why" = "Q2"
      )
    ) %>%
    mutate(
      ID.date = lubridate::floor_date(
        lubridate::as_date(as.integer(.data$ID.date), origin = "1900-01-01"),
        "month"
      ),
      Q1 = as.numeric(gsub("\\D+", "", .data$Q1)),
      Overall_why = stringr::str_replace_all(
        .data$Overall_why,
        "[^[:alnum:][:space:]]", ""
      ),
      Q4 = stringr::str_replace_all(.data$Q4, "[^[:alnum:][:space:]]", "")
    )

  save(data, file = "data/data.rda")
  data
}



#' Prepare targets
#'
#' Cleans and prepares raw data, saving it as an .rda file in data folder.
#'
#' @param raw_data A data-frame-like object
#'
#' @return Prepared targets
#'
#' @noRd
#'
targets_prep <- function(raw_data) {
  targets <- raw_data %>%
    mutate(
      ID.date = lubridate::floor_date(
        lubridate::as_date(as.integer(.data$ID.date), origin = "1900-01-01"),
        "month"
      )
    )

  save(targets, file = "data/targets.rda")
  targets
}
