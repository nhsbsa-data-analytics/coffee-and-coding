#' \code{fic} package
#'
#' Dashboard for Financial Information Collection Customer Satisfaction Survey.
#'
#' @docType package
#' @name fic
#'
#' @importFrom dplyr %>% arrange case_when desc filter group_by left_join mutate
#' @importFrom dplyr n rename rowwise select slice summarise ungroup
#' @importFrom shiny NS br column div fluidPage fluidRow h1 h2 HTML img
#' @importFrom shiny moduleServer reactive renderUI selectInput
#' @importFrom shiny shinyApp tagAppendAttributes tagList tags uiOutput
#' @importFrom highcharter hc_add_series hc_annotations hc_exporting hc_legend
#' @importFrom highcharter hc_plotOptions hc_tooltip hc_xAxis hc_yAxis hcaes
#' @importFrom highcharter highchart highchartOutput renderHighchart
#' @importFrom rlang .data := sym
#' @importFrom glue glue
NULL

## quiets concerns of R CMD check re: the .'s that appear in pipelines
if (getRversion() >= "2.15.1") utils::globalVariables(c("."))
