# import libraries
library(tidyverse)

# Qualitative test for normality.
head(mtcars)


# Check the distribution of vehicle weights from the built-in mtcars dataset in R. 
plt20 <- ggplot(mtcars, aes(x=wt)) 
plt20 + geom_density() + xlab("Vehicle Weight")



# Quantitative test for normality
# Recheck the distribution of vehicle weights using the Shapiro-Wilk test.
shapiro.test(mtcars$wt)


# visualize the distribution of driven miles for our entire population dataset, 
population_table <- read.csv('used_car_data.csv',check.names = F,stringsAsFactors = F) #import used car dataset

plt30 <- ggplot(population_table,aes(x=log10(Miles_Driven))) #import dataset into ggplot2
plt30 + geom_density() #visualize distribution using density plot



# create a sample dataset using dplyr's sample_n()function.
sample_table <- population_table %>% sample_n(50) #randomly sample 50 data points

plt31 <- ggplot(sample_table,aes(x=log10(Miles_Driven))) #import dataset into ggplot2
plt31 + geom_density() #visualize distribution using density plot


#  implement a one-sample t-test using the built-in stats package t.test()function.
# test if the miles driven from our previous sample dataset is statistically different from the miles driven in our population data, 
t.test(log10(sample_table$Miles_Driven),mu=mean(log10(population_table$Miles_Driven))) #compare sample versus population means


# test whether the mean miles driven of two samples from our used car dataset are statistically different.
sample_table1 <- population_table %>% sample_n(50) #generate 50 randomly sampled data points
sample_table2 <- population_table %>% sample_n(50) #generate 50 randomly sampled data points

t.test(log10(sample_table1$Miles_Driven),log10(sample_table2$Miles_Driven)) #compare means of two samples


# the modified mpg dataset (Links to an external site.) data file contains a modified version of R's built-in mpg dataset, where each 1999 vehicle was paired with a corresponding 2008 vehicle.
# generate our two data samples 
mpg_data <- read.csv('mpg_modified.csv') #import dataset
mpg_1999 <- mpg_data %>% filter(year==1999) #select only data points where the year is 1999
mpg_2008 <- mpg_data %>% filter(year==2008) #select only data points where the year is 2008

# use a paired t-test to determine if there is a statistical difference in overall highway fuel efficiency between vehicles manufactured in 1999 versus 2008.
# In other words, we are testing our null hypothesis—that the overall difference is zero. 
t.test(mpg_1999$hwy,mpg_2008$hwy,paired = T) #compare the mean difference between two samples



# ANOVA
# Is there any statistical difference in the horsepower of a vehicle based on its engine type?"
# Horsepower (the "hp" column) will be our dependent, measured variable
# number of cylinders (the "cyl" column) will be our independent, categorical variable.

# in the mtcars dataset, the cyl is considered a numerical interval vector, not a categorical vector.
# must clean our data before we begin

head(mtcars)
mtcars_filt <- mtcars[,c("hp","cyl")] #filter columns from mtcars dataset
mtcars_filt$cyl <- factor(mtcars_filt$cyl) #convert numeric column to factor

# Now that we have our cleaned dataset, we can use our aov()function as follows:
aov(hp ~ cyl,data=mtcars_filt) #compare means across multiple levels

#  To retrieve our p-values, we have to wrap our aov()function in a summary() function as follows:
summary(aov(hp ~ cyl,data=mtcars_filt))



# CORRELATION
# To practice calculating the Pearson correlation coefficient, we'll use the mtcars dataset. 
head(mtcars)
# test whether or not horsepower (hp) is correlated with quarter-mile race time (qsec).
plt32 <- ggplot(mtcars,aes(x=hp,y=qsec)) #import dataset into ggplot2
plt32 + geom_point() #create scatter plot

# use our cor() function to quantify the strength of the correlation between our two variables:
cor(mtcars$hp,mtcars$qsec) #calculate correlation coefficient



# For another example, let's reuse our used_cars dataset
used_cars <- read.csv('used_car_data.csv',stringsAsFactors = F) #read in dataset
head(used_cars)

# test whether or not vehicle miles driven and selling price are correlated.
plt33 <- ggplot(used_cars,aes(x=Miles_Driven,y=Selling_Price)) #import dataset into ggplot2
plt33 + geom_point() #create a scatter plot

# plot not helpful, calculate the Pearson correlation coefficient 
cor(used_cars$Miles_Driven,used_cars$Selling_Price) #calculate correlation coefficient


# correlation matrix 
# produce a correlation matrix for our used_cars dataset
# first need to select our numeric columns from our data frame and convert to a matrix. Then we can provide our numeric matrix to the cor() function 
used_matrix <- as.matrix(used_cars[,c("Selling_Price","Present_Price","Miles_Driven")]) #convert data frame into numeric matrix

cor(used_matrix)


# Linear regression 
# revisit our correlation example using the mtcars dataset. 
# Using our simple linear regression model, we'll test whether or not quarter-mile race time (qsec) can be predicted using a linear model and horsepower (hp
# Remember from our correlation example that our Pearson correlation coefficient's r-value was -0.71, which means there is a strong negative correlation between our variables. Therefore, we anticipate that the linear model will perform well.
# Create a linear regression model Y ~ A ( Y dependent, A independent)
lm(qsec ~ hp,mtcars) #create linear model

# determine our p-value and our r-squared value for a simple linear regression model,
summary(lm(qsec~hp,mtcars)) #summarize linear model

# visualize the fitted line against our dataset
#  calculate the data points to use for our line plot using our lm(qsec ~ hp,mtcars) coefficients
model <- lm(qsec ~ hp,mtcars) #create linear model

yvals <- model$coefficients['hp']*mtcars$hp + 
  model$coefficients['(Intercept)'] #determine y-axis values from linear model

# Once we have calculated our line plot data points, we can plot the linear model over our scatter plot:
plt34 <- ggplot(mtcars,aes(x=hp,y=qsec)) #import dataset into ggplot2
plt34 + geom_point() + geom_line(aes(y=yvals), color = "red") #plot scatter and linear model



# Multiple Linear Regression
#  revisit our mtcars dataset. From our last example, we determined that quarter-mile time was not adequately predicted from just horsepower.
# add other variables of interest such as fuel efficiency (mpg), engine size (disp), rear axle ratio (drat), vehicle weight (wt), and horsepower (hp) as independent variables to our multiple linear regression model.

lm(qsec ~ mpg + disp + drat + wt + hp,data=mtcars) #generate multiple linear regression model

# Now that we have our multiple linear regression model, we need to obtain our statistical metrics using the summary()function. In your R console,
summary(lm(qsec ~ mpg + disp + drat + wt + hp,data=mtcars)) #generate summary statistics

# perform correlation analysis on our previous datasets.
head(mtcars)
used_matrix1 <- as.matrix(mtcars[,c("qsec", "cyl", "vs", "am", "gear", "carb", "mpg",  "disp",  "drat",  "wt",  "hp")]) #convert data frame into numeric matrix
cor(used_matrix1)

lm(qsec ~ cyl + carb + vs + mpg + disp + drat + wt + hp,data=mtcars) #generate multiple linear regression model

summary(lm(qsec ~ cyl + carb + vs + mpg + disp + drat + wt + hp,data=mtcars)) #generate summary statistics


###################################

# categorical data

# test whether there is a statistical difference in the distributions of vehicle class across 1999 and 2008 from our mpg dataset
#  first need to build our contingency table 
table(mpg$class,mpg$year) #generate contingency table

# pass the contingency table to the chisq.test()function:
tbl <- table(mpg$class,mpg$year) #generate contingency table
chisq.test(tbl) #compare categorical distributions
















