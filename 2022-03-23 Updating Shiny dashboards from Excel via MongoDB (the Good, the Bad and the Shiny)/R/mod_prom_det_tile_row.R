#' prom_det_tile_row UI Function
#'
#' @description Shows a set of tiles with numbers of promoters and detractors
#' for a specific month, along with the final NPS score.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
mod_prom_det_tile_row_ui <- function(id) {
  ns <- NS(id)

  uiOutput(ns("tile_row"))
}

#' prom_det_tile_row Server Function
#' @description Creates a set of tiles with numbers of promoters and detractors
#' for a specific month, along with the final score NPS score.
#'
#' @param id String id, to match the corresponding UI element
#' @param month_index Index of month to use; starts at 1 for latest existing
#' month in the data, then 2 for 2nd latest etc.
#' @param r A reactiveValues object
#'
#' @noRd
#'
mod_prom_det_tile_row_server <- function(id, month_index, r) {
  moduleServer(id, function(input, output, session) {
    output$tile_row <- renderUI({
      data <- r$fic_data %>%
        filter(.data$ID.date == r$months()[month_index]) %>%
        group_by(.data$Q1) %>%
        summarise(total = n())

      question <- r$fic_data %>%
        filter(.data$ID.date == r$months()[month_index]) %>%
        select(.data$Q1) %>%
        stats::na.omit()

      prom <- round(sum(data$total[data$Q1 %in% c(9:10)]) / sum(data$total) * 100)
      det <- round(sum(data$total[data$Q1 %in% c(1:6)]) / sum(data$total) * 100)
      score <- NPS::nps(question$Q1, breaks = list(1:6, 7:8, 9:10)) * 100

      sign <- ""
      if (score > 0) {
        sign <- "+"
      }

      color <- "#DA291C"
      if (score >= r$fic_targets[month_index, ]$NPS.Target) {
        color <- "#009639"
      }

      HTML(
        glue(
          "{format(r$months()[month_index], format = '%B %Y')}",
          " (base: {sum(data$total)})",
          "<div style = 'padding-top: 10px; font-size: 22px; color: black;'>",
          "NPS = ",
          "<div class='ui horizontal label' style = 'font-size: 24px;",
          " background-color: #009639; color: white;'>",
          "Promoters ({prom}%)",
          "</div>",
          " - ",
          "<div class='ui horizontal label' style = 'font-size: 24px;",
          " background-color: #DA291C; color: white;'>",
          "Detractors ({det}%)",
          "</div>",
          " = ",
          "<div class='ui horizontal label' style = 'font-size: 24px;",
          " background-color: {color}; color: white;'>",
          "{sign} {round(score)}",
          "</div>",
          "</div>"
        )
      )
    })
  })
}
