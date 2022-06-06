# Read the colleagues cars data from csv file.
demo_table <- read.csv(file='demo.csv', check.names=F, stringsAsFactors=F)
# Import jsonlite library into R environment.
library(jsonlite)
# Read the used car data from the JSON file.
demo_table2 <- fromJSON(txt='demo.json')
# Select datapoints from a vector.
x <- c(3, 3, 2, 2, 5, 5, 8, 8, 9)
x[3]
x[6]
# Select data from two-dimensional data structure.
demo_table[3, "Year"]
demo_table[3,3]
# Select a column as a vector.
demo_table$Vehicle_Class
demo_table$"Vehicle_Class"
# Then select a single value from the vector.
demo_table$Vehicle_Class[2]
# Filter used car data to show only vehicles > $10,000 using brackets.
filter_table <- demo_table2[demo_table2$price > 10000,]
# Filter used car dataset by price and drivetrain, using subset().
filter_table2 <- subset(demo_table2, price > 10000 & drive == "4wd" & "clean" %in% title_status)
  
# other option to use brackets is cumbersome.
filter_table3 <- demo_table2[("clean" %in% demo_table2$title_status) & (demo_table2$price > 10000) & (demo_table2$drive == "4wd"),]

# Get a random sample from a vector using sample()
sample(c("cow", "deer", "pig", "chicken", "duck", "sheep", "dog"), 4)

# Get a random sample from a two-dimensional data structure.
# 1. Create a numerical vector with the same length as the number of rows, e.g. in demo_table:
num_rows <- 1:nrow(demo_table)
# 2. Use sample() to sample a list of indices from our first vector:
sample_rows <- sample(num_rows, 3)
# 3. Use brackets to retrieve data frame rows from sample list.
demo_table[sample_rows,]
# Combine 3 steps in one command line:
demo_table[sample(1:nrow(demo_table), 3),]

# Using dplyr library.
# Add columns to original dataframe for coworkers cars table.
demo_table <- demo_table %>% mutate(Mileage_per_year=Total_Miles/(2020-Year), IsActive=TRUE)

# Group the used car data by vehicle condition and determine the average mileage per condition.
# Create summary table.
summarize_demo <- demo_table2 %>% group_by(condition) %>% summarize(Mean_Mileage=mean(odometer), .groups = 'keep')

# to the previous summary table, add max price for each condition and the vehicles in each category. 
summarize_demo <- demo_table2 %>% group_by(condition) %>% 
  summarize(Mean_Mileage=mean(odometer), Maximum_Price=max(price), Num_Vehicles=n(), .groups = 'keep')

# Read the new demo2.csv file into a data frame.
demo_table3 <- read.csv('demo2.csv', check.names = F, stringsAsFactors = F)

# Data in demo_table3 is in wide format becuase different metrics were collected from a single vehicle.
## and each metric was stored as a separate column. 
# change this dataset to a long format using gather()
long_table <- gather(demo_table3, key="Metric", value="Score", buying_price:popularity)

# or use pipe operator without data source. 
long_table <- demo_table3 %>% gather(key="Metric", value="Score", buying_price:popularity)

# inversely, spread out the previouse long_table data frame back to its original format.
wide_table <- long_table %>% spread(key="Metric", value="Score")

# Check if the newly created wide_table is exactly as the original demo_table3.
all.equal(demo_table3, wide_table)

# reorder columns in both tables, then compare
table <- demo_table3[,order(colnames(wide_table))]
# or 
table <- demo_table3[,(colnames(wide_table))]
all.equal(table, demo_table3)

# Explore the mpg dataset that contains fuel economy data from the EPA for vehicles manufactured btwn 1999-2008.
## mpg dataset is built into R. 
# Create a bar plot to represent the distribution of vehicle classes.
plt <- ggplot(mpg, aes(x=class)) # import dataset into ggplot2
plt + geom_bar() # plot a bar plot

# Compare the number of vehicles from each manufacturer.
mpg_summary <- mpg %>% group_by(manufacturer) %>%
  summarize(Vehicle_Count=n(), .groups = 'keep') # Create summary table.
plt2 <-ggplot(mpg_summary, aes(x=manufacturer, y=Vehicle_Count)) # Import dataset into ggplot2
plt2 + geom_col() # plot a bar plot.

# Formatting the bar plot with labels then rotate the labels. 
plt2 + geom_col() + xlab("Manufacturing Company") + ylab("Number of Vehicles in Dataset") + theme(axis.text.x = element_text(angle = 45, hjust = 1)) #rotate the x-axis label 45 degrees

# Compare the difference in avg highway fuel economy of Toyota vehicles as a function of the different cylinder sizes.
mpg_summary2 <- subset(mpg, manufacturer == "toyota") %>% group_by(cyl) %>% summarize(Mean_Hwy=mean(hwy), .groups = 'keep') #create summary table
plt3 <- ggplot(mpg_summary2, aes(x=cyl, y=Mean_Hwy)) #import dataset into ggplot2
# plt3 + geom_line()
# Adjust the tick values by removing (5, 7) cyl and adding more y ticks for easier interpretation.
plt3 + geom_line() + scale_x_discrete(limits=c(4,6,8)) + scale_y_continuous(breaks = c(15:30)) #add line plot with labels

# show mpg dataset
head(mpg)

# create a scatter plot to visualize the relationship between the size of each car engine (displ) versus their city fuel efficiency (cty). 
plt4 <- ggplot(mpg, aes(x=displ, y=cty)) #import dataset into ggplot2
plt4 + geom_point() + xlab("Engine Size (L)") + ylab("City Fuel-Efficiency (MPG)") #add scatter plot with labels.

# Apply custom aesthetics to the previous scatter plot
plt5 <- ggplot(mpg, aes(x=displ, y=cty, color=class)) #import dataset into ggplot2
plt5 + geom_point() + labs(x="Engine Size (L)", y="City Fuel-Efficiency (MPG)", color="Vehicle Class") #add scatter plot with labels.

# Add shape grouping based on type of drive. 
plt6 <- ggplot(mpg, aes(x=displ, y=cty, color=class, shape=drv)) #import dataset into ggplot2
plt6 + geom_point() + labs(x="Engine Size (L)", y="City Fuel-Efficiency (MPG)", color="Vehicle Class", shape="Type of Drive") #add scatter plot with multiple aesthetics

# Create an additional visualization that uses City Fuel-Efficiency (MPG) to determine the size of the data point.
plt7 <- ggplot(mpg, aes(x=displ, y=cty, color=class, shape=drv, size=cty)) #import dataset into ggplot2
plt7 + geom_point() + labs(x="Engine Size (L)", y="City Fuel-Efficiency (MPG)", color="Vehicle Class", shape="Type of Drive", size="City Fuel-Efficiency (MPG)") #add scatter plot with multiple aesthetics

# better to have only 3-4 customizations, so remove shape. 
plt8 <- ggplot(mpg, aes(x=displ, y=cty, color=class, size=cty)) #import dataset into ggplot2
plt8 + geom_point() + labs(x="Engine Size (L)", y="City Fuel-Efficiency (MPG)", color="Vehicle Class", size="City Fuel-Efficiency (MPG)") #add scatter plot with multiple aesthetics

# Generate a boxplot to visualize the highway fuel efficiency of our mpg dataset.
plt9 <- ggplot(mpg, aes(y=hwy)) #import dataset into ggplot2
plt9 + geom_boxplot() + ylab("Highway Fuel-Efficiency (MPG)") #add boxplot

# Expanding on our previous example, we want to create a set of boxplots that compares highway fuel efficiency for each car manufacturer.
plt10 <- ggplot(mpg, aes(x=manufacturer, y=hwy)) #import dataset into ggplot2
plt10 + geom_boxplot(outlier.color = "red") + xlab("Manufacturer") + ylab("Highway Fuel-Efficiency (MPG)") + scale_y_continuous(breaks = seq(0, 45, by=5)) + theme(axis.text.x = element_text(angle=45, hjust=1)) #add boxplot and rotate x-axis labels 45 degrees.

# Add the type of drive (4-wheel, fwd, rwd) to the boxplot as a color aesthetic.
plt11 <- ggplot(mpg, aes(x=manufacturer, y=hwy, color=drv)) #import dataset into ggplot2
plt11 + geom_boxplot() + xlab("Manufacturer") + ylab("Highway Fuel-Efficiency (MPG)") + scale_y_continuous(breaks = seq(0, 45, by=5)) + theme(axis.text.x = element_text(angle=45, hjust=1)) #add boxplot and rotate x-axis labels 45 degrees.
plt11 + geom_boxplot() + labs(x="Manufacturer", y="Highway Fuel-Efficiency (MPG)", color="Drive Type") + scale_y_continuous(breaks = seq(0, 45, by=5)) + theme(axis.text.x = element_text(angle=45, hjust=1)) #add boxplot and rotate x-axis labels 45 degrees.

# Create a heatmap to visualize the average highway fuel efficiency across the type of vehicle class from 1999-2008.
mpg_summary3 <- mpg %>% group_by(class, year) %>% summarize(Mean_Hwy=mean(hwy), .groups = 'keep') #create summary table
plt12 <- ggplot(mpg_summary3, aes(x=class, y=factor(year), fill=Mean_Hwy))
plt12 + geom_tile() + labs(x="Vehicle Class", y="Vehicle Year", fill="Mean Highway (MPG)") #create heatmap with labels.

# Create a heatmap to visualize the difference in average highway fuel efficiency across each vehicle model from 1999-2008.
mpg_summary4 <- mpg %>% group_by(model, year) %>% summarize(Mean_Hwy=mean(hwy), .groups = 'keep') #create summary table
plt13 <- ggplot(mpg_summary4, aes(x=model, y=factor(year), fill=Mean_Hwy)) #import dataset into ggplot2
plt13 + geom_tile() + labs(x="Model", y="Vehicle Year", fill="Mean Highway (MPG)") +
  theme(axis.text.x = element_text(angle=90, hjust=1, vjust = .5)) #add heatmap with labels and rotate x-axis labels 90 degrees

# Recreate the boxplot comparing the highway fuel efficiency across manufactureres and over a scatter plot on top.
plt14 <- ggplot(mpg, aes(x=manufacturer, y=hwy)) #import dataset into ggplot2
plt14 + geom_boxplot() + labs(x="Manufacturer", y="Highway Fuel-Efficiency (MPG)") + #add boxplot
  theme(axis.text.x = element_text(angle=45, hjust=1)) + #rotate x-axis labels 45 degrees
  geom_point() #overlay scatter plot on top

# Compare average engine sizes for each vehicle class.
mpg_summary5 <- mpg %>% group_by(class) %>% summarize(Mean_Engine=mean(displ), .groups = 'keep') #create summary table
plt15 <- ggplot(mpg_summary5, aes(x=class, y=Mean_Engine)) #import dataset into ggplot2
plt15 + geom_point(size=4) + labs(x="Vehicle Class", y="Mean Engine Size") #add scatter plot.

# Add a layer to previous plot to provide context around the sd of the engine size for each vehicle class.
mpg_summary6 <- mpg %>% group_by(class) %>% summarize(Mean_Engine=mean(displ), SD_Engine=sd(displ), .groups = 'keep')
plt16 <- ggplot(mpg_summary6, aes(x=class, y=Mean_Engine)) #import dataset into ggplot2
plt16 + geom_point(size=4) + labs(x="Vehicle Class", y="Mean Engine Size") + #add scatter plot with labels
  geom_errorbar(aes(ymin=Mean_Engine-SD_Engine, ymax=Mean_Engine+SD_Engine)) #overlay with error bars

# Convert mpg dataset from wide format (current) into long format to use the facet function.
mpg_long <- mpg %>% gather(key="MPG_Type", value="Rating", c(cty, hwy)) #convert to long format.
head(mpg_long)

# Visualize the different vehicle fuel efficiency ratings by manufacturer. 
plt17 <- ggplot(mpg_long, aes(x=manufacturer, y=Rating, color=MPG_Type)) #import dataset into ggplot2
plt17 + geom_boxplot() + labs(x="Manufacturer", y="Fuel-Efficiency Ratings") + 
  theme(axis.text.x = element_text(angle=45, hjust=1)) #add boxplot with labels rotated 45 degrees.

# Facet the previous boxplot by the fuel-efficiency type (city vs highway).
plt18 <- ggplot(mpg_long, aes(x=manufacturer, y=Rating, color=MPG_Type)) #import dataset into ggplot2
plt18 + geom_boxplot() + facet_wrap(vars(MPG_Type)) + #create multiple boxplots, one for each MPG type
  theme(axis.text.x = element_text(angle=45, hjust=1), legend.position = "none") + labs(x="Manufacturer", y="Fuel-Efficiency Rating") #rotate x-axis labels


plt170 <- ggplot(mpg, aes(x=manufacturer, y=Rating, color=MPG_Type)) #import dataset into ggplot2
plt170 + geom_boxplot() + labs(x="Manufacturer", y="Fuel-Efficiency Ratings") + theme(axis.text.x = element_text(angle=45, hjust=1)) #add boxplot with labels rotated 45 degrees.

head(mpg)
head(mpg_long)

mpg_summary0 <- mpg %>% group_by(cty, hwy) %>% summarize(Rating=mean(cty, hwy), .groups = 'keep') #create summary table
plt171 <- ggplot(mpg_summary5, aes(x=manufacturer, y=Rating)) #import dataset into ggplot2
plt171 + geom_boxplot() + labs(x="Manufacturer", y="Fuel-Efficiency Rating") #add boxplot.

# Skill Drill: create another plot with a different variable in the facet_wrap().
plt180 <- ggplot(mpg_long, aes(x=manufacturer, y=Rating, color=MPG_Type)) #import dataset into ggplot2
plt180 + geom_boxplot() + facet_wrap(vars(drv)) + #create multiple boxplots, one for each MPG type
  theme(axis.text.x = element_text(angle=45, hjust=1), legend.position = "right") + labs(x="Manufacturer", y="Fuel-Efficiency Rating") + scale_y_continuous(breaks = seq(0, 45, by=2)) #rotate x-axis labels


