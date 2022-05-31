#' fixed_header UI Function
#'
#' @description Shows a fixed header with  dashboard title, subtitle and logo.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
mod_fixed_header_ui <- function(id) {
  ns <- NS(id)
  div(
    class = "container-fluid fixed-header",
    div(
      id = "mbie-header",
      br(),
      fluidRow(
        col_12(
          div(
            class = "float-right",
            img(
              src = "www/bsa_logo.svg",
              height = "60px",
              name = "NHSBSA logo",
              alt = "NHS Business Services Authority logo",
              padding = "10px"
            ),
            br()
          )
        ),
      ),
      fluidRow(
        col_12(
          div(
            h1("NHS Pensions Financial Information Collection (FIC)"),
            h2("Monthly customer satisfaction survey")
          ),
        ),
      )
    )
  )
}

#' fixed_header Server Function
#'
#' @description Not needed currently.
#'
#' @noRd
mod_fixed_header_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  })
}
