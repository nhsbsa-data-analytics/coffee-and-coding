reasonBarDems <- function(data, column, title, color) {
  data <- data %>%
    select(
      Month,
      !!column
    ) %>%
    select(
      !!column
    ) %>%
    na.omit() %>%
    rename(
      "Question" = 1
    ) %>%
    filter(
      Question != "Don't know",
      Question != "Don't know/can't remember",
      Question != "Don't know/cannot remember",
      Question != "Prefer not to say",
      Question != "If you use another term, please select this option and type in the box below"
    ) %>%
    group_by_all() %>%
    count() %>%
    ungroup() %>%
    mutate(
      Question = case_when(
        grepl("Other", Question) ~ "Other",
        TRUE ~ Question
      )
    )%>%
    arrange(
      desc(n)
    ) %>%
    mutate(
      `%` = round(n / sum(n) * 100, 3)
    ) %>%
    mutate(
      Question = case_when(
        `%` == 0 ~ "Other",
        TRUE ~ Question
      )
    )%>%
    mutate(`%` = round(`%`)) %>%
    group_by(
      Question
    )%>%
    summarise(
      n = sum(n)
    ) %>%
    ungroup() %>%
    mutate(
      `%` = round(n / sum(n) * 100)
    ) %>%
    arrange(
      desc(n)
    ) %>%
    arrange(Question %in% c("Other"))%>%
    arrange(Question %in% c("I have not used my certificate yet"))%>%
    arrange(Question %in% c("I have not collected any medication since receiving my maternity exemption certificate"))%>%
    arrange(Question %in% c("I have not collected any medication since receiving my medical exemption certificate"))%>%
    arrange(Question %in% c("I have not collected any medication since getting my prescription prepayment certificate"))%>%
    arrange(Question %in% c("I have not yet collected any medication since receiving my NHS tax credit exemption certificate"))%>%
    arrange(Question %in% c("No")) %>%
    arrange(Question %in% c("7 days or less"))%>%
    arrange(Question %in% c("8-15 days"))%>%
    arrange(Question %in% c("16-28 days"))%>%
    arrange(Question %in% c("29 days or more"))%>%
    arrange(Question %in% c("Not received"))%>%
    arrange(Question %in% c("7 working days or less"))%>%
    arrange(Question %in% c("8 to 18 working days"))%>%
    arrange(Question %in% c("19 to 28 working days"))%>%
    arrange(Question %in% c("29 working days or more"))%>%
    arrange(Question %in% c("Within 1 day"))%>%
    arrange(Question %in% c("2-7 days"))%>%
    arrange(Question %in% c("8-15 days"))%>%
    arrange(Question %in% c("16-28 days"))%>%
    arrange(Question %in% c("29 days or more"))%>%
    arrange(Question %in% c("Not received"))%>%
    arrange(Question %in% c("29 or more days"))%>%
    arrange(Question %in% c("Other"))%>%
    arrange(Question %in% c("Not received"))%>%
    arrange(Question %in% c("16-24"))%>%
    arrange(Question %in% c("25-44"))%>%
    arrange(Question %in% c("45-64"))%>%
    arrange(Question %in% c("65-74"))%>%
    arrange(Question %in% c("75+"))%>%
    arrange(Question %in% c("Prefer not to say"))
  
  base <- sum(data$n)
  
  if(base >= 100) {
    base <- formatC(base, format = "d", big.mark = ",")
  } else {
    base <- paste0(formatC(base, format = "d", big.mark = ","), "*")
  }
  
  highchart() %>%
    hc_add_series(
      type = "bar",
      color = color,
      # name = format(month, format = "%B %Y"),
      data = data,
      hcaes(
        x = Question,
        y = `%`,
        n = n
      )
    ) %>%
    hc_xAxis(
      type = "category"
    ) %>%
    hc_legend(
      enabled = F
    ) %>%
    hc_yAxis(
      title = list(
        text = "% responses"
      )
    ) %>%
    hc_title(
      text = title
    ) %>%
    hc_subtitle(
      text = paste0("Base: ", base)
    ) %>%
    hc_tooltip(
      pointFormat = "n: <b>{point.n}</b><br/>%: <b>{point.y}</b><br/>"
    )
}
