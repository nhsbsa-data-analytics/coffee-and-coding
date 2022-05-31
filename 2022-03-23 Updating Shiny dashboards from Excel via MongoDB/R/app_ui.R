#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#'
#' @noRd
app_ui <- function(request) {
  fluidPage(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    mod_fixed_header_ui("header_1"),
    fluidPage(
      br(),
      content_box(
        glue(
          "Overall satisfaction with all aspects of the ",
          "Financial Information Collection (FIC) Service"
        ),
        mod_3_month_nps_groups_ui("nps_groups_3_month"),
        br(),
        fluidRow(
          col_9(
            mod_prom_det_tile_row_ui("current-0"),
            br(),
            mod_prom_det_tile_row_ui("current-1"),
            br(),
            mod_prom_det_tile_row_ui("current-2")
          ),
          col_3(
            h2(tags$b("Targets")),
            tags$b("Q1 = +75 | Q2 = +75 | Q3 = +75 | Q4 = +75"),
            mod_3_month_tile_ui("nps_3_month_tile")
          )
        )
      ),
      br(),
      content_box(
        "NPS over time",
        mod_monthly_chart_ui("nps_monthly")
      ),
      br(),
      content_box(
        "Reason for overall satisfaction ratings",
        mod_table_group_select_ui("overall_why")
      ),
      br(),
      content_box(
        "NetEasy Score",
        fluidRow(
          col_9(
            mod_monthly_chart_ui("nes_monthly")
          ),
          col_3(
            fluidRow(
              h2(tags$b("Targets")),
              tags$b("Q1 = +85 | Q2 = +85 | Q3 = +85 | Q4 = +85"),
              mod_3_month_tile_ui("nes_3_month_tile")
            )
          )
        )
      ),
      br(),
      content_box(
        "Suggestions for improvements",
        mod_table_group_select_ui("suggestions")
      )
    ),
    br(),
    mod_footer_ui("footer_1")
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @importFrom golem add_resource_path favicon bundle_resources
#'
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www", app_sys("app/www")
  )

  tags$head(
    lang = "en",
    favicon(ext = "png"),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "NHS Pensions FIC Feedback"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
