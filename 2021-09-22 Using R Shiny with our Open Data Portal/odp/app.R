library(shiny)
library(ggplot2)
library(dplyr)
library(jsonlite)
library(crul)
library(highcharter)
library(readxl)
library(shinycssloaders)
library(shinyWidgets)
library(rgdal)
library(leaflet)

#define nhs colour scheme
nhsBlues <- c("#003087", "#005EB8", "#0072CE", "#41B6E6", "#00A9CE")
nhsGreys <- c("#425563", "#768692", "#E8EDEE")
nhsGreens <- c("#006747", "#009639", "#78BE20", "#00A499")
nhsPinks <- c("#330072", "#7C2855", "#AE2573")
nhsReds <- c("#8A1538", "#DA291C")
nhsYellows <- c("#ED8B00", "#FFB81C", "#FAE100")

# Define UI for application that draws a histogram
ui <- fluidPage(
  ## add css style to app
  tags$head(tags$style(HTML(
    paste0(
      "
      * {
      font-family:arial!important;
      }

      .infoText {
      font-weight: bold;
      }

      .box {
      padding: 5px;
      width: 400px;
      height: auto;
      border: 2px solid #000;
      margin: 0 auto 15px;
      text-align: left;
      font-weight: bold;
      border-radius: 10px;
      }

      .info {
      background-color: #ddd;
      border-color: #aaa;
      }
     "
    )
  ))),
  
  # Application title
  titlePanel("Open Data Portal | NHSBSA"),
  
  
  #main panel
  mainPanel(
    fluidRow(column(
      3,
      withSpinner(uiOutput("bnfSelector"), color = nhsGreens[1])
    ),
    column(
      3,
      withSpinner(uiOutput("monthSelector"), color = nhsGreens[1])
    ),
    column(
      3,
      withSpinner(uiOutput("pcoCode"), color = nhsGreens[1])
    )),
    div(class = "infoText",
        textOutput("infoText")),
    downloadLink('downloadData', 'Download data (.csv)'),
    br(),
    br(),
    fluidRow(column(3,
                    div(
                      class = "info box",
                      textOutput("bnfChapter")
                    )),
             column(3,
                    div(
                      class = "info box",
                      textOutput("nicCost")
                    )),
             column(3,
                    div(
                      class = "info box",
                      textOutput("actCost")
                    ))),
    fluidRow(column(
      6,
      withSpinner(highchartOutput("distPlot", height = "500px"), color = nhsGreens[1])
    ),
    column(
      6,
      withSpinner(highchartOutput("bnfPlot", height = "500px"), color = nhsGreens[1])
    )),
    fluidRow(column(12,
                    leafletOutput("itemsMap")))
  )
  
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  #load in BNF lookup table
  bnf_lookup <- data.frame(read_excel("data\\bnf_lookup.xlsx"))
  
  #load in PCO lookup table
  pco_lookup <- data.frame(read_excel("data\\pco_lookup.xlsx"))
  
  #read in postcode polygon data for mapping
  postcodes = readOGR("./data/postcode_polygons.gpkg", layer = "postcode_district")
  postcodes = spTransform(postcodes, CRS("+proj=longlat +datum=WGS84"))
  postcodes$pc_district <- as.character(postcodes$pc_district)
  
  #render select input for bnf
  output$bnfSelector <- renderUI({
    shiny::selectizeInput(
      "bnfCode",
      "Select BNF Chemical Substance:",
      choices = unique(bnf_lookup$BNF.Chemical.Substance),
      selected = "Aspirin",
      options = list(maxOptions = 5000)
    )
  })
  
  #render select input for available months
  output$monthSelector <- renderUI({

    dataset_id <- "english-prescribing-data-epd"
    base_endpoint <- "https://opendata.nhsbsa.net/api/3/action/"
    package_list_method <-
      "package_list"     # List of data-sets in the portal
    package_show_method <-
      "package_show?id=" # List all resources of a data-set
    action_method <- "datastore_search_sql?"  # SQL action method
    
    metadata_repsonse <- jsonlite::fromJSON(paste0(base_endpoint,
                                                   package_show_method,
                                                   dataset_id))
    
    # Resource names and IDs are kept within the resources table returned from the
    # package_show_method call.
    resources_table <- metadata_repsonse$result$resources %>%
      arrange(desc(name))
    
    shiny::selectInput(
      "month",
      "Select data set:",
      choices = unique(resources_table$name),
      selected = unique(resources_table$name)[1]
    )
  })
  
  #render selectinput for area tema code
  output$pcoCode <- renderUI({
    shiny::selectizeInput(
      "pcoCode",
      "Select Primary Care Organisation:",
      choices = unique(pco_lookup$PCO_NAME),
      selected = "NEWCASTLE GATESHEAD CCG",
      options = list(maxOptions = 5000)
    )
  })
  
  
  
  #api call for data
  apiData <- reactive({
    req(input$bnfCode)
    req(input$month)
    req(input$pcoCode)
    
    # Define the url for the API call
    base_endpoint <- "https://opendata.nhsbsa.net/api/3/action/"
    package_list_method <-
      "package_list"     # List of data-sets in the portal
    package_show_method <-
      "package_show?id=" # List all resources of a data-set
    action_method <- "datastore_search_sql?"  # SQL action method
    
    # Define the parameters for the SQL query
    resource_name <-
      input$month # For EPD resources are named EPD_YYYYMM
    
    substance <-
      bnf_lookup$BNF.Chemical.Substance.Code[which(bnf_lookup$BNF.Chemical.Substance == input$bnfCode)]
    
    pco_code <- pco_lookup$PCO_CODE[which(pco_lookup$PCO_NAME == input$pcoCode)]
    bnf_chemical_substance <- substance 
    
    # Build SQL query (WHERE criteria should be enclosed in single quotes)
    single_month_query <- paste0(
      "SELECT
            *
            FROM `",
      resource_name,
      "`
            WHERE
            1=1
            AND pco_code = '",
      pco_code,
      "'
            AND bnf_chemical_substance = '",
      bnf_chemical_substance,
      "'"
    )
    
    # Build API call
    single_month_api_call <- paste0(
      base_endpoint,
      action_method,
      "resource_id=",
      resource_name,
      "&",
      "sql=",
      URLencode(single_month_query) # Encode spaces in the url
    )
    
    # Grab the response JSON as a list
    single_month_response <-
      jsonlite::fromJSON(single_month_api_call)
    
    # Extract records in the response to a dataframe
    single_month_df <-
      data.frame(single_month_response$result$result$records)
    
    single_month_df
  })
  
  
  #conditional text to explain if there are zero results returned from call
  output$infoText <- renderText({
    req(apiData())
    text <- paste0("")
    
    if (nrow(apiData()) == 0) {
      text <-
        "There are no results availble for your selections, please select other options above."
    }
    
    text
  })
  
  
  #create data download
  output$downloadData <- downloadHandler(
    filename = function() {
      "data.csv"
    },
    content = function(file) {
      write.csv(apiData(), file)
    }
  )
  
  #output name of bnf chapter
  output$bnfChapter <- renderText({
    req(input$bnfCode)
    req(nrow(apiData()) > 0)
    
    paste0("BNF Chapter: ", apiData()$BNF_CHAPTER_PLUS_CODE[1])
    
  })
  
  #output total nic
  output$nicCost <- renderText({
    req(input$bnfCode)
    req(nrow(apiData()) > 0)
    
    paste0("Net ingredient costs: £",
           prettyNum(
             round(sum(apiData()$NIC), 2),
             big.mark = ",",
             format = "f",
             nsmall = 2
           ))
    
  })
  
  #output total actual cost
  output$actCost <- renderText({
    req(input$bnfCode)
    req(nrow(apiData()) > 0)
    
    paste0("Actual costs: £",
           prettyNum(
             round(sum(apiData()$ACTUAL_COST), 2),
             big.mark = ",",
             format = "f",
             nsmall = 2
           ))
    
  })
  
  
  #plot of practice names
  output$distPlot <- renderHighchart({
    req(input$bnfCode)
    req(nrow(apiData()) > 0)
    
    chartData <-
      apiData() %>%
      group_by(PRACTICE_NAME) %>%
      summarise(n = sum(ITEMS)) %>%
      arrange(desc(n))
    
    highchart() %>%
      hc_add_series(
        type = "column",
        color = nhsBlues[2],
        name = "Items",
        data = chartData,
        hcaes(x = PRACTICE_NAME,
              y = n)
      ) %>%
      hc_xAxis(type = "category") %>%
      hc_title(text = "Total items dispensed by practice") %>%
      hc_credits(enabled = TRUE)
    
    
    
  })
  
  #plot of bnf description
  output$bnfPlot <- renderHighchart({
    req(input$bnfCode)
    req(nrow(apiData()) > 0)
    
    chartData <-
      apiData() %>%
      group_by(BNF_DESCRIPTION) %>%
      summarise(n = sum(ITEMS)) %>%
      arrange(desc(n))
    
    highchart() %>%
      hc_add_series(
        type = "column",
        color = nhsGreens[2],
        name = "Items",
        data = chartData,
        hcaes(x = BNF_DESCRIPTION,
              y = n)
      ) %>%
      hc_xAxis(type = "category") %>%
      hc_yAxis(type = "logarithmic") %>%
      hc_title(text = "Total items dispensed by BNF description") %>%
      hc_credits(enabled = TRUE)
    
    
    
  })
  
  
  output$itemsMap <- renderLeaflet({
    req(input$bnfCode)
    req(nrow(apiData()) > 0)
    
    counts <- apiData() %>%
      select(ITEMS, POSTCODE) %>%
      mutate(POSTCODE = gsub(" .*$", "", POSTCODE)) %>%
      group_by(POSTCODE) %>%
      summarise(n = sum(ITEMS))
    
    print(counts)
    
    postcodes <-
      postcodes[postcodes$pc_district %in% counts$POSTCODE, ]
    
    codes <- data.frame(postcodes$pc_district) %>%
      rename(POSTCODE = 1) %>%
      left_join(counts)
    postcodes$counts <- codes$n
    
    num <- round(max(counts$n) / 9)
    
    if (num == 0) {
      num <- 1
    }
    
    
    bins <-
      c(0, num, num * 2, num * 3, num * 4, num * 5, num * 6, num * 7, num * 8, Inf)
    pal <-
      colorBin("YlOrRd", domain = postcodes$counts, bins = bins)
    labels <- sprintf("<strong>%s</strong><br/>%g items",
                      postcodes$pc_district,
                      postcodes$counts) %>% lapply(htmltools::HTML)
    
    tag.map.title <- tags$style(
      HTML(
        "
     .leaflet-control.map-title {
    transform: translate(-50%,20%);
    position: fixed !important;
    left: 50%;
    text-align: center;
    padding-left: 10px;
    padding-right: 10px;
    background: rgba(255,255,255,0.75);
    font-weight: bold;
    font-size: 28px;
  }
"
      )
    )
    
    
    title <- tags$div(tag.map.title,
                      HTML("Map showing items dispensed by postcode district"))
    
    
    leaflet(postcodes,
            width = "100%") %>%
      addTiles() %>%
      addPolygons(
        fillColor = ~ pal(counts),
        weight = 2,
        opacity = 1,
        color = "#005EB8",
        dashArray = "3",
        fillOpacity = 0.7,
        highlight = highlightOptions(
          weight = 5,
          color = "#666",
          dashArray = "",
          fillOpacity = 0.7,
          bringToFront = TRUE
        ),
        label = labels,
        labelOptions = labelOptions(
          style = list("font-weight" = "normal", padding = "3px 8px"),
          textsize = "15px",
          direction = "auto"
        )
      ) %>%
      addLegend(
        pal = pal,
        values = ~ counts,
        opacity = 0.7,
        title = "Items dispensed",
        position = "bottomright"
      ) %>%
      addControl(title, position = "topleft", className = "map-title")
    
  })
}

# Run the application
shinyApp(ui = ui, server = server)
