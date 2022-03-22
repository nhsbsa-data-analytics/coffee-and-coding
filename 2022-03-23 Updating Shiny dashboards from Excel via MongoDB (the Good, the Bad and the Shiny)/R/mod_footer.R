#' footer UI Function
#'
#' @description Standard footer with contact and accessibility statement links.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
mod_footer_ui <- function(id) {
  ns <- NS(id)
  div(
    class = "ui page grid container dashboard",
    div(
      class = "sixteen wide column",
      div(class = "ui divider"),
      div(
        style = "margin-left: 14px;",
        div(
          style = "margin-left: 14px;",
          "This Dashboard was produced by the NHSBSA Management Information Team.",
          br(),
          "If you have any queries, please contact us at",
          enurl(
            "mailto:nhsbsa.managementinformation@nhs.net",
            "nhsbsa.managementinformation@nhs.net"
          ),
          ".",
          br(),
          enurl(
            glue(
              "https://nhsbsauk.sharepoint.com/sites/Accessibility/SitePages/",
              "Accessibility-statement-for-Management-Information-RShiny-Dashboards.aspx"
            ),
            "Click here if you wish to view our accessibility statement."
          )
        )
      )
    )
  )
}

#' footer Server Function
#'
#' @description Not needed currently.
#'
#' @noRd
mod_footer_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
  })
}
