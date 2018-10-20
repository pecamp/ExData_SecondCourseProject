##########################################################################
# Program:  This is a script for the second course project for Coursera's
#           EDA course. The script generates a plot addressing the
#           question below:
# 
#           How have emissions from motor vehicle sources changed from
#           1999-2008 in Baltimore City?
# 
# Author:   Philip Camp
# Date:     2018 Oct 19
###########################################################################

# Clear global environment
rm(list = ls())

# Library packages
library(plyr)
library(dplyr)
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
baltimore       <- subset(NEI, fips == "24510")

# Subset out "Mobile Vehicles" in the SCC table
# Note: "Mobile Vehicles" are defined the the EI.Vector variable as being Mobile and having
# Vehicle in its name
motorVehicleSCC <- unique(SCC[grep("Mobile.*Vehicles", SCC$EI.Sector),]$SCC)

# Filter out baltimore NEI data by the SCC with Motor Vehicles
baltMVData      <- filter(baltimore, SCC %in% motorVehicleSCC)

# Summarize data by year
pm25ByYear      <- ddply(baltMVData, ~year, summarize, total = sum(Emissions))

# Plot data and save
p <- ggplot(pm25ByYear, aes(factor(year), total)) +
  geom_bar(stat = "identity") + 
  ylab(expression("PM"[2.5]*" Emissions (tons)")) +
  xlab("Year") + 
  ggtitle(expression("Motor Vehicle PM"[2.5]*" Emissions (tons) in the US from 1999-2008")) + 
  theme_bw()

ggsave("plot5.png", plot = p, width = 8, height = 5)
