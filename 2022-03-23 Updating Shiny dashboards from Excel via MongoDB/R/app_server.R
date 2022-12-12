
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#'
#' @noRd
app_server <- function(input, output, session) {
  eval_lines(".mongo-credentials")

  r <- rv()

  load_data(r, "data")
  load_data(r, "targets")

  r$months <- reactive(
    sort(unique(r$fic_data$ID.date), decreasing = TRUE)
  )

  mod_3_month_nps_groups_server("nps_groups_3_month", r)
  mod_prom_det_tile_row_server("current-0", 1, r)
  mod_prom_det_tile_row_server("current-1", 2, r)
  mod_prom_det_tile_row_server("current-2", 3, r)
  mod_3_month_tile_server("nps_3_month_tile", "NPS", r)
  mod_monthly_chart_server("nps_monthly", "NPS", r)
  mod_table_group_select_server("overall_why", "Overall_why", r)
  mod_monthly_chart_server("nes_monthly", "NES", r)
  mod_3_month_tile_server("nes_3_month_tile", "NES", r)
  mod_table_group_select_server("suggestions", "Q4", r)
}
