
# Import libraries
library(dplyr)
library(tidyverse)

# Import and read data file.
MechaCar_mpg <- read.csv(file = './Resources/MechaCar_mpg.csv', check.names = F, stringsAsFactors = F)

# Display the dataframe
head(MechaCar_mpg)


# 1. Multiple Linear Regression to Predict MPG

# Perform Multiple Linear Regression using all six variables. 
lm(mpg ~ vehicle_length + vehicle_weight + spoiler_angle + ground_clearance + AWD,data=MechaCar_mpg) 

# Determine the p-value and r-squared for the model. 
summary(lm(mpg ~ vehicle_length + vehicle_weight + spoiler_angle + ground_clearance + AWD,data=MechaCar_mpg))











