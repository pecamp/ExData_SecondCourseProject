##########################################################################
# Program:  This is a script for the second course project for Coursera's
#           EDA course. The script generates a plot addressing the
#           question below:
# 
#           Compare emissions from motor vehicle sources in Baltimore City
#           with emissions from motor vehicle sources in Los Angeles County,
#           California (fips=="06037"). Which city has seen greater changes
#           over time in motor vehicle emissions?
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
baltimoreLA       <- subset(NEI, fips == "24510" | fips == "06037")

# Assign fips as city
baltimoreLA$fips  <- factor(baltimoreLA$fips, levels = c("06037", "24510"),
                            labels = c("Los Angeles", "Baltimore"))

# Subset out "Mobile Vehicles" in the SCC table
# Note: "Mobile Vehicles" are defined the the EI.Vector variable as being Mobile and having
# Vehicle in its name
motorVehicleSCC <- unique(SCC[grep("Mobile.*Vehicles", SCC$EI.Sector),]$SCC)

# Filter out baltimore NEI data by the SCC with Motor Vehicles
baltLAMVData      <- filter(baltimoreLA, SCC %in% motorVehicleSCC)

# Summarize data by year
pm25ByYear        <- ddply(baltLAMVData  , .(fips,year), summarize, 
                           total = sum(Emissions),
                           mean  = mean(Emissions),
                           median = median(Emissions))

# Plot data and save
p <- ggplot(pm25ByYear, aes(factor(year), total, fill = fips)) +
  geom_bar(stat = "identity") + 
  facet_grid(fips~., scales = "free") +
  ylab(expression("PM"[2.5]*" Emissions (tons)")) +
  xlab("Year") + 
  ggtitle(expression("Motor Vehicle PM"[2.5]*" Emissions (tons) in LA and Baltimore from 1999-2008")) + 
  theme_bw() +
  guides(fill = FALSE)

ggsave("plot6.png", plot = p, width = 8, height = 5)