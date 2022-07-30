
# Import libraries
library(dplyr)
library(tidyverse)

# Import and read the MechaCar_mpg.csv data file.
MechaCar_mpg <- read.csv(file = './Resources/MechaCar_mpg.csv', check.names = F, stringsAsFactors = F)

# Display the dataframe
head(MechaCar_mpg)


# 1. Multiple Linear Regression to Predict MPG

# Perform Multiple Linear Regression using all six variables. 
lm(mpg ~ vehicle_length + vehicle_weight + spoiler_angle + ground_clearance + AWD,data=MechaCar_mpg) 

# Determine the p-value and r-squared for the model. 
summary(lm(mpg ~ vehicle_length + vehicle_weight + spoiler_angle + ground_clearance + AWD,data=MechaCar_mpg))


# 2. Visualizations for Trip Analysis using suspension data

# Import and read the Suspension_Coil.csv data file. 
suspension_table <- read.csv(file = './Resources/Suspension_Coil.csv', check.names = F, stringsAsFactors = F)

# Display the dataframe
head(suspension_table)

# Get the mean, median, variance, and standard deviation of the suspension coil's PSI column.
total_summary <- suspension_table %>% summarize(Mean=mean(PSI), Median=median(PSI), Variance=var(PSI), SD=sd(PSI))
head(total_summary)

# Get the mean, median, variance, and standard deviation of the suspension coil's PSI for each manufacturing lot. 
lot_summary <- suspension_table %>% group_by(Manufacturing_Lot) %>% 
  summarize(Mean=mean(PSI), Median=median(PSI), Variance=var(PSI), SD=sd(PSI))

head(lot_summary)



