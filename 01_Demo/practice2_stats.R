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
