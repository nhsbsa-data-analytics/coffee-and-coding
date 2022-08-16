# 4.2 Install a package    
# install.packages("tidyverse") type this code below



# 4.3 Using a Package 
# library(tidyverse)



# 4.4 Getting help with a Package
# help(package="dplyr")



# 5.1 Get Working directory
# getwd() 



# 5.2 Set Working directory
# setwd()



# 6.1 Load CSV, from current directory
# first_table <- read_csv("Mydata.csv")



# 6.1 Load CSV, from a different directory
# second_table <- read_csv("C:/Users/cypher/CSVS/Mydata2.csv")



# 6.2 Load excel from current directory 
# third_table <- read_excel("Mydata3.xlsx")



# 6.2 Load excel from different directory
# fourth_table <- read_excel("C:/Users/cypher/EXCEL/Mydata4.xlsx")



# 7 Simple analysis in R - Get mtcars data
# mtcars <- mtcars



# 7.1 Sum up a column
# num_cyl <- mtcars %>% 
# summarise(sum(cyl))



# 7.2 Filter rows
# Cylinders4 <- mtcars %>% 
# filter(cyl == 4)




# 7.2 Filer using more than one field
# Cylinders4_mpgn <- mtcars %>% 
# filter(cyl == "4" & mpg >"30")




# 7.3 Grouping data
# Num_cars = mtcars %>% 
# group_by(cyl) %>% 
# summarise(number_of_cars = n())




# 8 Drawing a graph
# ggplot(data=Num_cars, aes(x= cyl, y= number_of_cars)) +
# geom_bar(stat="identity")





# 8 Changing value to a factor
# Num_cars <- Num_cars %>% 
# mutate(cyl= as.factor(cyl))




# 8 re-plot graph
# ggplot(data=Num_cars, aes(x= cyl, y= number_of_cars)) +
# geom_bar(stat="identity")




# 8.1 Change the color of the bars
# ggplot(data=Num_cars, aes(x= cyl, y= number_of_cars)) +
# geom_bar(stat="identity", fill="steelblue")




# 8.1 make the bars different colours
# ggplot(data=Num_cars, aes(x= cyl, y= number_of_cars, fill = cyl)) +
# geom_bar(stat="identity")




#.8.2 Adding a title to the graph
# ggplot(data=Num_cars, aes(x= cyl, y= number_of_cars, fill = cyl)) +
# geom_bar(stat="identity")+
# ggtitle("Number of cars by number of Cylinders")




#8.3 Adding axis labels
# ggplot(data=Num_cars, aes(x= cyl, y= number_of_cars, fill = cyl)) +
# geom_bar(stat="identity")+
# ggtitle("Number of cars by number of Cylinders") +
# xlab("Number of Cylinders") +
# ylab("Number of Cars")


