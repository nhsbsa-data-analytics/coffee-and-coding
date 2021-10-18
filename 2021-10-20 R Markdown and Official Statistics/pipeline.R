
# Now we'll look at how we can quickly produce customised reports on a large 
# scale. In this example we're going to be using the flights data set again.
# But this time we're going to produce individual reports for each carrier that
# had a flight departing an NYC airport in 2013 containing some standard measures

# This pipeline script will be the main script that we execute in order to 
# populate the 'carriers.Rmd' script and render it. It operates and is structured
# like a normal R script

# library packages required
library(nycflights13)
library(lubridate)
library(highcharter)
library(dplyr)
library(scales)
library(rmarkdown)

# lets clean our environment to make sure that variables from flights.Rmd don't
# interfere with this script
rm(list = ls())

# we can set global options here instead of in the 'carriers.Rmd' script.
hcoptslang <- getOption("highcharter.lang")
hcoptslang$thousandsSep <- ","
options(highcharter.lang = hcoptslang)

# create our flights2 data set with included date and month columns
flights2 <- flights %>% 
  # use dplyr mutate function to create a new column
  mutate(date = as.Date(format(time_hour, "%Y-%m-%d")),
         
         # we'll use the month() function from the lubridate package here to
         # quickly give us the name of a month from its numeric representation
         month_name = month(date, label = TRUE, abbr = FALSE)) 

# TODO: now lets have a quick look at 'carriers.Rmd' and how we've authored it.
# IMPORTANT: notice that the YAML parameter 'self_contained' has now been set to
# false? this allows the R markdown document to access variables in our global
# environment

# create our summary data set
carrier_delays_all_df <- flights2 %>% 
  group_by(month_name, month, carrier) %>% 
  summarise(num_flights = n(),
            delayed_flights = sum(dep_delay > 0, na.rm = TRUE),
            delayed_flights_per = delayed_flights / num_flights * 100,
            .groups = "drop")

# create our summary data set
carrier_avg_delays_all_df <- flights2 %>% 
  group_by(month_name, month, carrier) %>% 
  summarise(avg_delay = mean(dep_delay[dep_delay > 0], na.rm = TRUE),
            .groups = "drop") 

# Now its time for us to construct our for loop to iterate through every carrier
# and produce a report for each one. For loops iterate through vectors, lists,
# data frames, and other objects and execute a set of instructions for every 
# element in that object.
# First lets build a simple loop to understand what they do

# in this loop we are asking R, for each element of 1 to 10, print that element
for (i in 1:10) print(i)

# i is just a signifier for accessing an element of the object. you can use 
# anything you want
for (numbers in 1:10) print(numbers)

# in this loop we're asking R to perform an operation on the element
for (i in 1:10) print(2^i)

# if you want a more complicated set of instructions to be executed on the element
# then you can wrap them in {} - curly braces to use multiple lines
for(i in 1:10) {
  x <- 2^i
  
  text <- paste("the value of x is:", x)
  
  print(text)
}

# for our loop to render each markdown report first we need a unique list of 
# carriers in the flights data set
carriers <- unique(flights2$carrier)

# a dplyr solution to this if you're more used to that would be:
# carriers <- flights2 %>% distinct(carrier) %>% pull()

# now lets write the loop!
for (carrier_nm in carriers) {
  
  # first we need to filter our data sets to show only data relevant to the
  # carrier
  carrier_delays_df <- carrier_delays_all_df %>% 
    filter(carrier == carrier_nm)
  
  carrier_avg_delays_df <- carrier_avg_delays_all_df %>% 
    filter(carrier == carrier_nm)

  # and finally, call the render() function from the rmarkdown package to knit
  # the document and output to an output folder.
  render(input = "2021-10-20 R Markdown and Official Statistics/carriers.Rmd",
         output_file = paste0("carrier-report-", carrier_nm, ".html"),
         output_dir = "2021-10-20 R Markdown and Official Statistics/outputs")
  
}
