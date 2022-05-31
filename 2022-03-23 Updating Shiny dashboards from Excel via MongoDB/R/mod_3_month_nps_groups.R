#' 3_month_nps_groups UI Function
#'
#' @description Shows a barchart, with a bar for each of past 3 months for each
#' of the NPS values possible (1-10).
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
mod_3_month_nps_groups_ui <- function(id) {
  ns <- NS(id)

  highchartOutput(
    ns("nps_groups"),
    height = "250px"
  )
}

#' 3_month_nps_groups Server Function
#'
#' @description Creates a barchart, with a bar for each of past 3 months for each
#' of the NPS values possible (1-10).
#'
#' @param id String id, to match the corresponding UI element
#' @param r A reactiveValues object
#'
#' @noRd
#'
mod_3_month_nps_groups_server <- function(id, r) {
  moduleServer(id, function(input, output, session) {
    output$nps_groups <- renderHighchart({
      rows <- as.data.frame(c(1:10))
      names(rows) <- "Q1"

      chart <- r$fic_data %>%
        filter(
          .data$ID.date == r$months()[1]
        ) %>%
        group_by(
          .data$Q1
        ) %>%
        summarise(
          total = n()
        )

      chart <- merge(chart, rows, all = T)
      chart[is.na(chart)] <- 0
      chart$color <- "#DA291C"
      chart$color[chart$Q1 == 7 | chart$Q1 == 8] <- "#ED8B00"
      chart$color[chart$Q1 == 9 | chart$Q1 == 10] <- "#009639"
      chart$per <- chart$total / sum(chart$total) * 100

      chart2 <- r$fic_data %>%
        filter(
          .data$ID.date == r$months()[2]
        ) %>%
        group_by(
          .data$Q1
        ) %>%
        summarise(
          total = n()
        )

      chart2 <- merge(chart2, rows, all = T)
      chart2[is.na(chart2)] <- 0
      chart2$color <- "#768692"
      chart2$per <- chart2$total / sum(chart2$total) * 100

      chart3 <- r$fic_data %>%
        filter(.data$ID.date == r$months()[3]) %>%
        group_by(.data$Q1) %>%
        summarise(total = n())

      chart3 <- merge(chart3, rows, all = T)
      chart3[is.na(chart3)] <- 0
      chart3$color <- "#768692"
      chart3$per <- chart3$total / sum(chart3$total) * 100

      highchart() %>%
        hc_add_series(
          chart,
          "column",
          name = format(r$months()[1], format = "%B %Y"),
          hcaes(
            x = .data$Q1,
            y = .data$per,
            color = .data$color,
            total = .data$total
          )
        ) %>%
        hc_add_series(
          chart2,
          "column",
          name = format(r$months()[2], format = "%B %Y"),
          hcaes(
            x = .data$Q1,
            y = .data$per,
            color = .data$color,
            total = .data$total
          )
        ) %>%
        hc_add_series(
          chart3,
          "column",
          name = format(r$months()[3], format = "%B %Y"),
          hcaes(
            x = .data$Q1,
            y = .data$per,
            color = .data$color,
            total = .data$total
          )
        ) %>%
        hc_xAxis(
          allowDecimals = F,
          labels = list(
            style = list(
              fontSize = "24px",
              color = "black"
            )
          ),
          plotLines = list(
            list(
              value = 6.5,
              color = "grey",
              width = 1,
              dashStyle = "dash"
            ),
            list(
              value = 8.5,
              color = "grey",
              width = 1,
              dashStyle = "dash"
            )
          )
        ) %>%
        hc_legend(
          enabled = F
        ) %>%
        hc_annotations(
          list(
            labels = list(
              list(
                point = list(
                  x = 3.5,
                  y = 25,
                  xAxis = 0,
                  yAxis = 0
                ),
                text = paste0(
                  "Detractors ",
                  prettyNum(
                    sum(
                      chart$total[chart$Q1 %in% c(1:6)]
                    ),
                    big.mark = ","
                  ),
                  " (",
                  round(
                    sum(
                      chart$total[chart$Q1 %in% c(1:6)]
                    ) / sum(
                      chart$total
                    ) * 100
                  ),
                  "%)"
                ),
                shape = "square",
                backgroundColor = "#DA291C",
                style = list(
                  fontSize = "16px"
                )
              ),
              list(
                point = list(
                  x = 7.5,
                  y = 25,
                  xAxis = 0,
                  yAxis = 0
                ),
                text = paste0(
                  "Passives ",
                  prettyNum(
                    sum(
                      chart$total[chart$Q1 %in% c(7:8)]
                    ),
                    big.mark = ","
                  ),
                  " (",
                  round(
                    sum(
                      chart$total[chart$Q1 %in% c(7:8)]
                    ) / sum(
                      chart$total
                    ) * 100
                  ),
                  "%)"
                ),
                shape = "square",
                backgroundColor = "#ED8B00",
                style = list(
                  fontSize = "16px"
                )
              ),
              list(
                point = list(
                  x = 9.5,
                  y = 25,
                  xAxis = 0,
                  yAxis = 0
                ),
                text = paste0(
                  "Promoters ",
                  prettyNum(
                    sum(
                      chart$total[chart$Q1 %in% c(9:10)]
                    ),
                    big.mark = ","
                  ),
                  " (",
                  round(
                    sum(
                      chart$total[chart$Q1 %in% c(9:10)]
                    ) / sum(
                      chart$total
                    ) * 100
                  ),
                  "%)"
                ),
                shape = "square",
                backgroundColor = "#009639",
                style = list(
                  fontSize = "16px"
                )
              )
            )
          )
        ) %>%
        hc_tooltip(
          shared = T,
          pointFormat = glue(
            "<span style='color:{{point.color}}'>\u25CF</span> ",
            "{{series.name}}: <b>{{point.total}}</b><br/>"
          ),
          headerFormat = NULL
        ) %>%
        hc_plotOptions(
          column = list(
            pointPadding = 0
          )
        ) %>%
        hc_yAxis(
          max = max(chart$per, chart2$per, chart3$per),
          title = list(
            text = "Responses (%)"
          )
        )
    })
  })
}
