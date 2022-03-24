#' table_with_group_select UI Function
#'
#' @description Shows a table with month, comment and NPS group. Includes a
#' select input to filter to a specific group.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
mod_table_group_select_ui <- function(id) {
  ns <- NS(id)
  div(
    selectInput(
      ns("npsgroup"),
      "Select rating group:",
      c("All", "Detractor", "Passive", "Promoter")
    ),
    DT::dataTableOutput(ns("table"))
  )
}

#' table_with_group_select Server Function
#'
#' @description Creates a table with month, comment and NPS group. Includes a
#' select input to filter to a specific group.
#'
#' @param id String id, to match the corresponding UI element
#' @param col_name String of the column name for comments to show.
#' month in the data, then 2 for 2nd latest etc.
#' @param r A reactiveValues object
#'
#' @noRd
#'
mod_table_group_select_server <- function(id, col_name, r) {
  moduleServer(id, function(input, output, session) {
    output$table <- DT::renderDataTable({
      table <- r$fic_data %>%
        filter(
          .data$ID.date %in% r$months()[1:3]
        ) %>%
        select(
          .data$ID.date,
          .data$Q1,
          !!col_name
        ) %>%
        mutate(
          Group = case_when(
            .data$Q1 > 8 ~ "Promoter",
            .data$Q1 > 6 ~ "Passive",
            .data$Q1 <= 6 ~ "Detractor"
          )
        ) %>%
        rename(
          Month  = 1,
          Score  = 2,
          Reason = 3,
          Group  = 4
        ) %>%
        arrange(
          desc(.data$Month),
          .data$Score
        ) %>%
        select(
          -.data$Score
        ) %>%
        mutate(
          Month = format(.data$Month, format = "%b %y")
        ) %>%
        filter(
          .data$Reason != ""
        )

      if (input$npsgroup != "All") {
        table <- table %>%
          filter(
            .data$Group == input$npsgroup
          )
      }

      DT::datatable(table, rownames = FALSE)
    })
  })
}
