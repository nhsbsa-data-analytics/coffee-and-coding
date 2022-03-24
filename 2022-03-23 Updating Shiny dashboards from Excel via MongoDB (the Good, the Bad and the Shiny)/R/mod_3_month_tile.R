#' nps_3_month_tile UI Function
#'
#' @description Shows a tile with the 3MR score for either NPS or NES. It is
#' coloured red or green according to whether the score is below or above the
#' target.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
mod_3_month_tile_ui <- function(id) {
  ns <- NS(id)

  uiOutput(ns("tile"))
}

#' nps_3_month_tile Server Function
#'
#' @description Creates a tile with the 3MR score for either NPS or NES. It is
#' coloured red or green according to whether the score is below or above the
#' target.
#'
#' @param id String id, to match the corresponding UI element
#' @param measure Either "NPS" or "NES"
#' @param r A reactiveValues object
#'
#' @noRd
#'
mod_3_month_tile_server <- function(id, measure, r) {
  moduleServer(id, function(input, output, session) {
    measure <- tolower(measure)
    measure_column <- switch(measure,
      "nps" = "Q1",
      "nes" = "NetEasy"
    )

    nes_ratings <- c(
      "Extremely difficult" = 1,
      "Very difficult" = 2,
      "Fairly difficult" = 3,
      "Neither easy nor difficult" = 7,
      "Fairly easy" = 8,
      "Very easy" = 9,
      "Extremely easy" = 10
    )

    output$tile <- renderUI({
      scores_3m <- r$fic_data %>%
        select(
          .data$ID.date,
          !!measure_column
        ) %>%
        stats::na.omit() %>%
        filter(
          !!measure_column != "",
          .data$ID.date %in% r$months()[1:3]
        ) %>%
        # Begin Exclude Linting
        {
          # End Exclude Linting
          if (measure == "nes") {
            rowwise(., .data$NetEasy) %>%
              mutate(
                NetEasy = nes_ratings[[.data$NetEasy]]
              )
          } else {
            .
          }
        } %>%
        group_by(
          .data$ID.date
        ) %>%
        summarise(
          base = n(),
          # Begin Exclude Linting
          "{measure}" := NPS::nps(!!(sym(measure_column))) * 100
          # End Exclude Linting
        ) %>%
        arrange(
          .data$ID.date
        ) %>%
        left_join(
          r$fic_targets,
          by = "ID.date"
        )

      score <- mean(scores_3m[[measure]])
      target <- r$fic_targets %>%
        filter(
          .data$ID.date %in% r$months()[1]
        )
      target <- target[[glue("{toupper(measure)}.Target")]][1]

      color <- "#009639"
      if (score < target) {
        color <- "#DA291C"
      }

      HTML(
        glue(
          "<div class='ui card' style = 'background-color: {color}'>",
          "<div class='content'>",
          "<div class='center aligned header' style = 'color: white;'>",
          "3 month rolling {toupper(measure)}",
          "</div>",
          "<div class='center aligned description'>",
          "<p style = 'font-weight:bolder; font-size: 60px; color: white;'>",
          "{round(score)}",
          "</p>",
          "</div>",
          "</div>",
          "</div>"
        )
      )
    })
  })
}
