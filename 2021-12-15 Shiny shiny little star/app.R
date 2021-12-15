library(DT)
library(highcharter)
library(readxl)
library(shiny)
library(tidyr)
library(dplyr)
library(stringr)
library(tidytext)
library(googlesheets4)
library(textdata)
library(tidyr)
library(lubridate)
library(RColorBrewer)
library(wordcloud2)
library(tm)
library(tidyverse)
library(qdapRegex)
library(reshape2)
library(chron)

#~~~~WARNING: before running this app, set the correct current month on the data page~~~~

#~~~~header function~~~~
mbie_header <- function()
  div(
    fluidRow(
      column(
        8,
        div(
          br(),
          h2("Christmas planninnnnng!!"),
          br()
        )),
      column(
        4,
        br(),
        img(src = "bsa_logo.svg", width = 300),
        br()
      )
    ),
    div(class = "mbie-topbar"))


source('./Pages/ui/ui.R', local = TRUE)

options(warn=-1)


server <- function(input, output, session) {
  
  source("utils.R", local = TRUE)
  source('./Pages/ui/pages/overall.R', local = TRUE)
  
  eval_lines("token.txt")
  
  values <- reactiveValues()

  #Allows the google sheets file to be accessed via the token id
  gs4_auth(email = 'helen.odonnell3@nhs.net', cache = 'token/', token = TOKEN)
  
  #The data sheet is read in and saved
  values$data_input <- read_sheet(ss = '1smjyczJJGjnbpT78NxLqar6-SUXHVkgXdjY1IMHNUB0', sheet = 'Sheet1', col_types = 'ncnnnnnnnnnnnn', col_names = TRUE)

  #This event happens when the log details button is clicked
  observeEvent(input$logButton, {

    #the input fields are used to create a tibble of details
    logging_details <<- tibble(
      ID = as.numeric(max(values$data_input$ID) + 1),
      Elf = as.character(input$bsa_elf),
      One = input$one_day,
      Two = input$two_day,
      Three = input$three_day,
      Four = input$four_day,
      Five = input$five_day,
      Six = input$six_day,
      Seven = input$seven_day,
      Eight = input$eight_day,
      Nine = input$nine_day,
      Ten = input$ten_day,
      Eleven = input$eleven_day,
      Twelve = input$twelve_day
    )

    #the tibble is added onto the bottom row of the LOGGING datatable in the Google Sheets database
    sheet_append(logging_details, ss = '1smjyczJJGjnbpT78NxLqar6-SUXHVkgXdjY1IMHNUB0', sheet = 'Sheet1')

    values$data_input <- read_sheet(ss = '1smjyczJJGjnbpT78NxLqar6-SUXHVkgXdjY1IMHNUB0', sheet = 'Sheet1', col_types = 'ncnnnnnnnnnnnn', col_names = TRUE)
    
    values$dataset <<- values$data_input %>%
      mutate(
        One = case_when(One == TRUE ~ 1, TRUE ~ 0),
        Two = case_when(Two == TRUE ~ 1, TRUE ~ 0),
        Three = case_when(Three == TRUE ~ 1, TRUE ~ 0),
        Four = case_when(Four == TRUE ~ 1, TRUE ~ 0),
        Five = case_when(Five == TRUE ~ 1, TRUE ~ 0),
        Six = case_when(Six == TRUE ~ 1, TRUE ~ 0),
        Seven = case_when(Seven == TRUE ~ 1, TRUE ~ 0),
        Eight = case_when(Eight == TRUE ~ 1, TRUE ~ 0),
        Nine = case_when(Nine == TRUE ~ 1, TRUE ~ 0),
        Ten = case_when(Ten == TRUE ~ 1, TRUE ~ 0),
        Eleven = case_when(Eleven == TRUE ~ 1, TRUE ~ 0),
        Twelve = case_when(Twelve == TRUE ~ 1, TRUE ~ 0),
        Total = (1*One)+(2*Two)+(3*Three)+(4*Four)+(5*Five)+(6*Six)+
          (7*Seven)+(8*Eight)+(9*Nine)+(10*Ten)+(11*Eleven)+(12*Twelve),
        Weight_Total = (11*One)+(2*Two)+(3*Three)+(4*Four)+(0.5*Five)+(5*Six)+
          (7*Seven)+(14*Eight)+(13*Nine)+(16*Ten)+(15*Eleven)+(17*Twelve)
      )
    
    latest_details <- values$dataset %>%
      filter(ID == max(ID))
    
    #The validation text is rendered to be displayed on the page
    output$submittedLogDetails <- renderText ({
      paste0("Details submitted. Total items taken: ", latest_details$Total[1], ". Total weight: ", latest_details$Weight_Total[1], "kg.")
    })
    
  })
  
}

shinyApp(ui = ui, server = server)
