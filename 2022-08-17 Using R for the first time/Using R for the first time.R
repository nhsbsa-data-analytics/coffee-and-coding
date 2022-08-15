## 3.2 Install a package    
## install.packages("tidyverse") type this code below


## 3.3 Using a Package 
## library(tidyverse)


## 3.4 Getting help with a Package
## help(package="dplyr")


## 4.1 Get Working directory
## getwd() 


## 4.2 Set Working directory
## setwd()

## 5.1 Load CSV, from current directory
## first_table <- read_csv("Mydata.csv")

## 5.1 Load CSV, from a different directory
## second_table <- read_csv("C:/Users/nidod/CSVS/Mydata2.csv")


## 5.2 Load excel from current directory 
## third_table <- read_excel("Mydata3.xlsx")


## 5.2 Load excel from different directory
##fourth_table <- read_excel("C:/Users/nidod/EXCEL/Mydata4.xlsx")


## 6 Simple analysis in R - Get mtcars data
## mtcars <- mtcars


##6.1 Sum up a column
##num_cyl <- mtcars %>% 
##  summarise(sum(cyl))

##6.2 Filter rows
## Cylinders4 <- mtcars %>% 
## filter(cyl == 4)

## 6.3 Filer using more than one field
##Cylinders4_mpgn <- mtcars %>% 
##filter(cyl == "4" & mpg >"30")

## 6.4 Grouping data
## Num_cars = mtcars %>% 
## group_by(cyl) %>% 
## summarise(number_of_cars = n())



