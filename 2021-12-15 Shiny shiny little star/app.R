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

local_secrets <- paste0(Sys.getenv("Home"),"/.secrets")
app_secrets   <- ".secrets"

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

  source('./Pages/ui/pages/overall.R', local = TRUE)

  values <- reactiveValues()

  ### FIRST TIME RUN ONLY ###
  ### Handling file path too long issue ###
  #' Set authentication token to be stored in a folder called `.secrets` in users
  #' Home directory, e.g."C:/Users/Mark/Documents/.secrets"
  # options(gargle_oauth_cache = local_secrets)

  #' Authenticate manually
  # gs4_auth()

  #' If successful, the previous step stores a token file.
  #' Check that a file has been created with:
  # list.files(app_secrets)

  #' Check that the non-interactive authentication works by first deauthorizing:
  # gs4_deauth()
  ### END FIRST TIME RUN ###

  ### USE cache = local_secrets FOR RUNNING LOCALLY ###
  #' Authenticate using token. If no browser opens, the authentication works.
  #' Replace the email with your own email.
  # gs4_auth(cache = local_secrets, email = "mark.mcpherson1@nhs.net")

  ### USE cache = app_secrets WHEN DEPLOYING ###
  ### REMEMBER TO COPY YOUR .secrets FOLDER INTO APP! ###
  gs4_auth(cache = app_secrets, email = "mark.mcpherson1@nhs.net")

  #The data sheet is read in and saved
  #https://docs.google.com/spreadsheets/d/131i5fa-I7XD3CYJWUyd5s52OXLBELWTOfrHv12Y5iio/edit?usp=sharing
  values$data_input <- read_sheet(ss = '131i5fa-I7XD3CYJWUyd5s52OXLBELWTOfrHv12Y5iio', sheet = 'Sheet1', col_types = 'ncnnnnnnnnnnnn', col_names = TRUE)
  #values$data_input <- read_sheet(ss = '1smjyczJJGjnbpT78NxLqar6-SUXHVkgXdjY1IMHNUB0', sheet = 'Sheet1', col_types = 'ncnnnnnnnnnnnn', col_names = TRUE)
  print(isolate(values$data_input))
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
    sheet_append(logging_details, ss = '131i5fa-I7XD3CYJWUyd5s52OXLBELWTOfrHv12Y5iio', sheet = 'Sheet1')

    values$data_input <- read_sheet(ss = '131i5fa-I7XD3CYJWUyd5s52OXLBELWTOfrHv12Y5iio', sheet = 'Sheet1', col_types = 'ncnnnnnnnnnnnn', col_names = TRUE)

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
