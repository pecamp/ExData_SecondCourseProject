##########################################################################
# Program:  This is a script for the second course project for Coursera's
#           EDA course. The script generates a plot addressing the
#           question below:
# 
#           Across the United States, how have emissions from coal 
#           combustion-related sources changed from 1999-2008?
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

# Subset out fuel combustion and coal sectors from the SCC table
coalCombSCC           <- SCC[grep("Fuel Comb.*Coal", SCC$EI.Sector),]$SCC

# Filter NEI table to only include the coal combustion sources
coalCombNEI           <- filter(NEI, SCC %in% coalCombSCC)

# Summarize data by year
pm25CoalCombByYear    <- ddply(coalCombNEI, ~year, summarize, total = sum(Emissions))

p <- ggplot(pm25CoalCombByYear, aes(factor(year), total)) +
  geom_bar(stat = "identity") + 
  ylab(expression("PM"[2.5]*" Emissions (tons)")) +
  xlab("Year") + 
  ggtitle(expression("Coal Combustion PM"[2.5]*" Emissions (tons) in the US from 1999-2008")) + 
  theme_bw()

ggsave("plot4.png", plot = p, width = 8, height = 5)

