# Purpose :	The goal of this scripts is simply to 
#           examine how household energy usage varies over a 2-day 
#           period in February, 2007. This will be done by generating
#           a plot to visualize the global active power across time
#
# Approach: 1. Download  the individual household electric power 
#              consumption Data Set.
#           2. Standardize data types
#           3. Generate plot to screen and to file
#
# Inputs:	  1. URL to download the data file
#
# Output:   2. Plot in PNG format
#
# Params	:	NONE.
#
# Calls	:	none.
# 
# Special	:	none.
# Notes	:	
# Author	:	Illich Martinez	Date : 08/09/2015
# Notice	:	
# 
# ************ START: EXECUTION SCRIPT *********************
# Source("plot2.R)	
# ************ END: EXECUTION SCRIPT *********************

# Download compressed data file
initialDir <- getwd()
dataDir <- "./data"
if(!file.exists(dataDir)){dir.create(dataDir)}
setwd(dataDir)
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zfile <- "household_power_consumption.zip"
download.file(fileUrl,destfile=zfile,mode="wb")

# Uncompress the data file
unzip(zfile)
dataFileName <- "household_power_consumption.txt"

# Extract only data from Feb 1 and 2 of 2007 
# The date format in the file is d/m/yyyy

#This library will allow us to use tsql syntax to only extract data for 
#those two days
library(sqldf) 

consumptionData <- read.csv.sql(dataFileName
                                ,sql = 'select *
                            from file 
                            where Date in ("1/2/2007","2/2/2007")',
                                ,header = TRUE
                                ,sep = ";")

#Standardize dates and times
Date2 <- as.Date(consumptionData$Date,format="%d/%m/%Y")
consumptionData$Time2 <- strptime(paste(consumptionData$Date,consumptionData$Time),format="%d/%m/%Y %H:%M:%S")
setwd(initialDir)

#Set plot global variables
par(mfcol=c(1,1))
par(mar=c(5,4,4,1))
par(cex=.8)

#Generate plot to sceen
with(consumptionData,
     plot(Time2, Global_active_power
         ,type="l"
         ,ylab="Global Active Power (kilowatts)"
         ,xlab="")
)

# The png device uses 480x480 pixels by default according to:
# https://stat.ethz.ch/R-manual/R-devel/library/grDevices/html/png.html
# I verified this once the files were created.
dev.copy(png, file = "plot2.png")
dev.off()

