ui <- fluidPage(
  title = "Ho-Ho-Ho...w many items can Santa bring?",
  div(class = "container-fluid",
      div(mbie_header())),
  div(
    class = "header-page",
    tags$link(rel = "stylesheet", type = "text/css", href = "stylesheet.css"),
    tags$head(tags$link(rel = "shortcut icon", href = "christmaspageicon.jpg")),
               fluidPage(
                 fluidRow(
                   column(
                     10,
                     "We need to fit as many items as possible in the sleigh, but still finish by 8am! Helpppp!!"
                   ),
                   column(
                     2,
                     textInput(
                       width = '100%',
                       "bsa_elf",
                       "BSA elf:"
                     )
                   ),
                   column(
                     3,
                     "What times should Santa bring?",
                     checkboxInput(
                       "one_day",
                       "A partridge in a pear tree"
                     ),
                     checkboxInput(
                       "two_day",
                       "Two turtle doves"
                     ),
                     checkboxInput(
                       "three_day",
                       "Three french hens"
                     ),
                     checkboxInput(
                       "four_day",
                       "Four calling birds"
                     ),
                     checkboxInput(
                       "five_day",
                       "Five golden rings"
                     ),
                     checkboxInput(
                       "six_day",
                       "Six geese a-laying"
                     ),
                     checkboxInput(
                       "seven_day",
                       "Seven swans a-swimming"
                     ),
                     checkboxInput(
                       "eight_day",
                       "Eight maids a-milking"
                     ),
                     checkboxInput(
                       "nine_day",
                       "Nine ladies dancing"
                     ),
                     checkboxInput(
                       "ten_day",
                       "Ten lords a-leaping"
                     ),
                     checkboxInput(
                       "eleven_day",
                       "Eleven pipers piping"
                     ),
                     checkboxInput(
                       "twelve_day",
                       "Twelve drummers drumming"
                     )
                   ),
                   column(
                     3,
                     highchartOutput("total_items")
                   ),
                   column(
                     6,
                     highchartOutput("time_remaining")
                   )
                 ),
                 fluidRow(
                   column(
                     12,
                     div(
                       actionButton("logButton",
                                    "Submit", icon("save"),
                                    style="color: #fff; background-color: #21ba45; border-color: #07ad2e"),
                       div(
                         class = 'right field', style = 'text-align: right;',
                         textOutput('submittedLogDetails')
                       )
                     )
                   )
                 )
      ),
  br(),
  div(class = 'ui page container dashboard',
      div(class = 'ui divider'),
      br(),
      div(class = 'ui page container dashboard',
          div(
            "This Dashboard was produced by the NHSBSA Christmas Planning Team.",
            "If you have any queries, please contact us at", a("nhsbsa.christmas.planning@nhs.net.", href = "mailto:nhsbsa.christmas.planning@nhs.net"),
            br(),
            a("Click here if you wish to view our accessibility statement.", href = "https://nhsbsauk.sharepoint.com/sites/Accessibility/SitePages/Accessibility-statement-for-Management-Information-RShiny-Dashboards.aspx")
          ))
  ),
  br()
)
)
