
#Need another chart to track the total, with the max items and name displayed

output$time_remaining <- renderHighchart({

  req(values$dataset)
  
  capital_data <- data.frame(
    Capital = c(
      "Nairobi", "Warsaw", "Cardiff", "Havana", "Brussels", "North Pole"
    ),
    Time = c(
      "00:00:00",
      "02:00:00", 
      "03:30:00", 
      "04:00:00", 
      "05:00:00",
      "06:30:00"
    )
  ) %>%
    mutate(
      Time_label = hms(Time),
      Time = as.numeric(as.difftime(Time), units = "hours"),
      Time_chart_label = as.character(times((Time*60%/%60 + Time*60%%60 /60)/24)),
      Time_chart_label = substring(Time_chart_label, 1, 5)
    )

  Usual_weight <- 40
  
  data_used <- values$dataset %>%
    filter(ID == max(ID)) %>%
    select(ID, Elf, Total, Weight_Total)
  
  factor <- data_used$Weight_Total/Usual_weight
  
  new_data <- capital_data %>%
    mutate(
      Time = Time*factor,
      Time_chart_label = paste0(0, paste(floor(Time), round((Time-floor(Time))*60), sep=":")),
      Time_chart_label = case_when(Time_chart_label == "00:0" ~ "00:00", TRUE ~ Time_chart_label),
      Time = paste(floor(Time), round((Time-floor(Time))*60), sep="."),
      Time = as.numeric(Time),
      Time_label = hm(Time)
    )
  
  if (length(values$dataset) == 0){
    highchart() %>%
      hc_title(text = "Will we make it back before 8am?") %>%
      hc_xAxis(type = "category",
               title = list(text = "Capital city")
      ) %>%
      hc_add_series(
        data = capital_data,
        hcaes(
          x = Capital,
          y = Time
        ),
        type = 'line',
        color = '#da291c',
        name = "Usual weight of 40",
        marker = list(
          symbol = "url(https://i.pinimg.com/originals/fd/04/30/fd0430c66db6864c738d7d6c461611ff.jpg)",
          width = 40,
          height = 40,
          radius = 4,
          fillColor = '#FFF',
          lineWidth = 4,
          enabled = TRUE,
          lineColor = NULL
        )
      ) %>%
      hc_tooltip(
        shared = FALSE,
        pointFormat = "<b>Time arrived: </b>{point.Time_chart_label}<br>",
        useHTML = TRUE) %>%
      hc_plotOptions(series = list(connectNulls = TRUE)) %>%
      hc_yAxis(title = list(text = "Time"),
               plotBands = list(
                 list(
                   label = list(text = "We need to get back before 8am!"),
                   color = "rgba(255, 0, 0, 0.4)",
                   from = 8,
                   to = 10
                 )
               )
      ) %>%
      hc_legend(enabled = TRUE)
  } else {
  highchart() %>%
    hc_title(text = "Will we make it back before 8am?") %>%
    hc_xAxis(type = "category",
             title = list(text = "Capital city")
             ) %>%
    hc_add_series(
      data = capital_data,
      hcaes(
        x = Capital,
        y = Time
      ),
      type = 'line',
      color = '#da291c',
      name = "Usual weight of 40",
      marker = list(
        symbol = "url(https://i.pinimg.com/originals/fd/04/30/fd0430c66db6864c738d7d6c461611ff.jpg)",
        width = 40,
        height = 40,
        radius = 4,
        fillColor = '#FFF',
        lineWidth = 4,
        enabled = TRUE,
        lineColor = NULL
      )
    ) %>%
    hc_add_series(
      data = new_data,
      hcaes(
        x = Capital,
        y = Time
      ),
      type = 'line',
      color = '#12c41e',
      name = "New test weight",
      marker = list(
        symbol = "url(https://www.studiocambridge.co.uk/wp-content/uploads/2020/12/12-days-of-Christmas.png)",
        width = 40,
        height = 40,
        radius = 4,
        fillColor = '#FFF',
        lineWidth = 4,
        enabled = TRUE,
        lineColor = NULL
      )
    ) %>%
    hc_tooltip(
      shared = FALSE,
      pointFormat = "<b>Time arrived: </b>{point.Time_chart_label}<br>",
      useHTML = TRUE) %>%
    hc_plotOptions(series = list(connectNulls = TRUE)) %>%
    hc_yAxis(title = list(text = "Time"),
             plotBands = list(
               list(
                 label = list(text = "We need to get back before 8am!"),
                 color = "rgba(255, 0, 0, 0.4)",
                 from = 8,
                 to = 10
               )
             )
             ) %>%
    hc_legend(enabled = TRUE)
  }
  
})

output$total_items <- renderHighchart({
  
  req(values$dataset)
  
  Usual_weight <- 40
  
  data_used <<- values$dataset %>%
    # select(ID, Elf, Total, Weight_Total) %>%
    mutate(factor = Weight_Total/Usual_weight) %>%
    filter(!factor > 8/6.5) %>%
    filter(Total == max(Total))

  items_combo <- data_used %>%
    gather(ID, Elf) %>%
    filter(!ID == "Total", !ID == "factor", !ID == "Weight_Total", !Elf == 0) %>%
    mutate(
      ID = case_when(
        ID == "One" ~ " A partridge in a pear tree",
        ID == "Two" ~ " Two turtle doves",
        ID == "Three" ~ " Three french hens",
        ID == "Four" ~ " Four calling birds",
        ID == "Five" ~ " Five golden rings",
        ID == "Six" ~ " Six geese a-laying",
        ID == "Seven" ~ " Seven swans a-swimming",
        ID == "Eight" ~ " Eight maids a-milking",
        ID == "Nine" ~ " Nine ladies dancing",
        ID == "Ten" ~ " Ten lords a-leaping",
        ID == "Eleven" ~ " Eleven pipers piping",
        ID == "Twelve" ~ " Twelve drummers drumming"
      )
    )

  latest_attempt <<- values$dataset %>%
    filter(ID == max(ID)) %>%
    mutate(
      Elf = paste0("Current elf: ", Elf)
    )

  latest_attempt_items_combo <- latest_attempt %>%
    gather(ID, Elf) %>%
    filter(!ID == "Total", !ID == "Weight_Total", !Elf == 0) %>%
    mutate(
      ID = case_when(
        ID == "One" ~ " A partridge in a pear tree",
        ID == "Two" ~ " Two turtle doves",
        ID == "Three" ~ " Three french hens",
        ID == "Four" ~ " Four calling birds",
        ID == "Five" ~ " Five golden rings",
        ID == "Six" ~ " Six geese a-laying",
        ID == "Seven" ~ " Seven swans a-swimming",
        ID == "Eight" ~ " Eight maids a-milking",
        ID == "Nine" ~ " Nine ladies dancing",
        ID == "Ten" ~ " Ten lords a-leaping",
        ID == "Eleven" ~ " Eleven pipers piping",
        ID == "Twelve" ~ " Twelve drummers drumming"
      )
    )
  
  joined <- latest_attempt %>%
    full_join(data_used) %>%
    mutate(
      colour = c("#da291c", "#12c41e")
    ) %>%
    arrange(desc(Total)) %>%
    ungroup()

  highchart() %>%
    hc_title(text = paste0("Maximum items brought so far, arriving by 8am. Items combination:")) %>%
    hc_subtitle(text = items_combo$ID) %>%#, latest_attempt_items_combo$ID) %>%
    hc_xAxis(type = "category",
             title = list(text = "Elf")
    ) %>%
    hc_add_series(
      data = joined,
      hcaes(
        x = Elf,
        y = Total
      ),
      type = 'column'
    ) %>%
    hc_colors(c("#12c41e")) %>%
    hc_tooltip(
      shared = FALSE,
      pointFormat = "<b>{point.Elf}: </b>{point.Total} items.<br>",
      valueDecimals = 0,
      useHTML = TRUE) %>%
    hc_yAxis(
      title = list(text = "Number of items")
    ) %>%
    hc_legend(enabled = FALSE)

})