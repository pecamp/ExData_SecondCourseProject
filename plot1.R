##########################################################################
# Program:  This is a script for the second course project for Coursera's
#           EDA course. The script generates a plot addressing the
#           question below:
# 
#           Have total emissions from PM2.5 decreased in the United States
#           from 1999 to 2008? Using the base plotting system, make a plot
#           showing the total PM2.5 emission from all sources for each of
#           the years 1999, 2002, 2005, and 2008.
# 
# Author:   Philip Camp
# Date:     2018 Oct 19
###########################################################################

# Clear global environment
rm(list = ls())

# Library packages
library(plyr)

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

# Organize total PM2.5 emissions by year
pm25ByYear    <- ddply(NEI, ~year, summarize, total = sum(Emissions))

# PNG plot
png("plot1.png", height = 480, width = 480, units = "px")

# Expand the graphical parameter margins
par(mar = c(5.1, 4.5, 4.1, 2.1))

# Plot the data
with(pm25ByYear, barplot(total/10^6, 
                         names = year, 
                         ylab = expression("PM"[2.5]*" Emissions (10"^6*" tons)"),
                         xlab = "Year",
                         main = expression("Total PM"[2.5]*" Emissions (10"^6*" tons) in the US from 1999-2008")))


# Detach device
dev.off()

