#' monthly_chart_ui UI Function
#'
#' @description Show a line chart of scores over time, including significant
#' change indicators and base sizes.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
mod_monthly_chart_ui <- function(id) {
  ns <- NS(id)

  highchartOutput(ns("chart"), height = "250px")
}

#' monthly_chart_ui Server Function
#'
#' @description Creates a line chart of scores over time, including significant
#' change indicators and base sizes.
#'
#' @param id String id, to match the corresponding UI element
#' @param measure Either "NPS" or "NES"
#' @param r A reactiveValues object
#'
#' @noRd
#'
mod_monthly_chart_server <- function(id, measure, r) {
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

    output$chart <- renderHighchart({
      chart <- r$fic_data %>%
        select(
          .data$ID.date,
          !!measure_column
        ) %>%
        stats::na.omit() %>%
        filter(
          !!measure_column != ""
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
          "{measure}" := round(NPS::nps(!!(sym(measure_column))) * 100)
          # End Exclude Linting
        ) %>%
        arrange(
          .data$ID.date
        ) %>%
        left_join(
          r$fic_targets,
          by = "ID.date"
        )

      group_totals <- r$fic_data %>%
        select(
          .data$ID.date,
          !!measure_column
        ) %>%
        stats::na.omit() %>%
        filter(
          !!measure_column != ""
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
        mutate(
          group = case_when(
            !!sym(measure_column) >= 9 ~ "positive",
            !!sym(measure_column) >= 7 ~ "passive",
            TRUE ~ "negative"
          )
        ) %>%
        group_by(
          .data$ID.date,
          .data$group
        ) %>%
        summarise(
          total = n()
        ) %>%
        ungroup() %>%
        tidyr::pivot_wider(
          names_from = .data$group,
          values_from = .data$total,
          values_fill = 0
        )

      chart <- chart %>%
        left_join(
          group_totals,
          by = "ID.date"
        )

      chart$prev_positive <- stats::lag(chart$positive, 1, 0)
      chart$prev_passive <- stats::lag(chart$passive, 1, 0)
      chart$prev_negative <- stats::lag(chart$negative, 1, 0)

      chart$sig <- ""

      for (i in seq_len(nrow(chart))) {
        chart$sig[i] <- nps_moe_test(
          chart$positive[i],
          chart$passive[i],
          chart$negative[i],
          chart$prev_positive[i],
          chart$prev_passive[i],
          chart$prev_negative[i]
        )
      }

      chart <- chart %>%
        mutate(
          sig = case_when(
            .data$sig == 1 ~ "<font color = '#009639', size = '5'>&uArr;</font>",
            .data$sig == 0 ~ "",
            .data$sig == -1 ~ "<font color = '#DA291C', size = '5'>&dArr;</font>"
          )
        )

      highchart() %>%
        hc_add_series(
          name = toupper(measure),
          color = "#005EB8",
          data = chart,
          type = "line",
          hcaes(
            y = !!measure,
            sig = .data$sig,
            target = !!glue("{toupper(measure)}.Target")
          )
        ) %>%
        hc_add_series(
          name = "Quarterly target",
          color = "black",
          data = chart,
          type = "line",
          hcaes(
            y = !!glue("{toupper(measure)}.Target")
          ),
          dataLabels = list(
            enabled = F
          ),
          marker = list(
            enabled = F
          ),
          dashStyle = "dash"
        ) %>%
        hc_xAxis(
          lineWidth = 0,
          tickLength = 0,
          categories = c(
            paste0(
              format(chart$ID.date, format = "%b %y"),
              "<br>(",
              prettyNum(chart$base, big.mark = ","),
              ")"
            )
          )
        ) %>%
        hc_plotOptions(
          series = list(
            pointPadding = 0,
            groupPadding = 0.005,
            dataLabels = list(
              allowOverlap = T,
              enabled = T,
              style = list(
                textOutline = "none",
                color = "black",
                fonWeight = "bolder",
                fontSize = "15px"
              ),
              formatter = highcharter::JS(
                "function() {var yval = this.point.y.toFixed(0);
                  if(this.point.y.toFixed(0) > 0) {
                    yval = '+' + yval
                  }
                  if(this.point.y.toFixed(0) >= this.point.target) {
                    yval = '<font color = #009639>' + yval +'</font>'
                  }
                  if(this.point.y.toFixed(0) < this.point.target) {
                    yval = '<font color = #DA291C>' + yval +'</font>'
                  }
                  return yval + this.point.sig
                }"
              ),
              useHTML = T,
              x = 24
            )
          )
        ) %>%
        hc_yAxis(
          max = 100,
          min = -100,
          tickColor = "black",
          tickInterval = 50
        ) %>%
        hc_tooltip(
          enabled = T,
          shared = T
        ) %>%
        hc_exporting(
          enabled = FALSE
        )
    })
  })
}
