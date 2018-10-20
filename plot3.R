##########################################################################
# Program:  This is a script for the second course project for Coursera's
#           EDA course. The script generates a plot addressing the
#           question below:
# 
#           Of the four types of sources indicated by the type 
#           (point, nonpoint, onroad, nonroad) variable, which of these 
#           four sources have seen decreases in emissions from 1999-2008
#           for Baltimore City? Which have seen increases in emissions 
#           from 1999-2008? Use the ggplot2 plotting system to make a
#           plot answer this question.
# 
# Author:   Philip Camp
# Date:     2018 Oct 19
###########################################################################

# Clear global environment
rm(list = ls())

# Library packages
library(plyr)
library(ggplot2)

# Set file names
rds1Name    <- "summarySCC_PM25.rds"
rds2Name    <- "Source_Classification_Code.rds"

# Look for the two RDS files. If not present in working directory
# download the data and unzip it
if(!(rds1Name %in% list.files() & rds2Name %in% list.files())){
  
  # Set data location parameters
  dataURL     <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  
  # Download and unzip data in your working directory
  download.file(url = dataURL, destfile = "NEI_data.zip")
  unzip("NEI_data.zip")
  
}

# Read-in the RDS files from the working directory
NEI <- readRDS(rds1Name)
SCC <- readRDS(rds2Name)

# Subset data to restrict to Baltimore City
baltimore     <- subset(NEI, fips == "24510")

# Summarize data for Baltimore by type and year
pm25ByTypeByYear    <- ddply(baltimore, .(type, year), summarize, total = sum(Emissions))

p <- ggplot(pm25ByTypeByYear, aes(year, total, col = type)) + 
  geom_line(linetype = 2, size = 2) +
  ylab(expression("PM"[2.5]*" Emissions (ton)")) +
  xlab("Year") + 
  ggtitle(expression("Total PM"[2.5]*" Emissions (ton) in Baltimore City, MD from 1999-2008 by Type")) + 
  theme_bw() + 
  scale_color_discrete(name = "Type")

ggsave("plot3.png", plot = p, width = 8, height = 5)

