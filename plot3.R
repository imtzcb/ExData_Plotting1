# Purpose : The goal of this scripts is simply to 
#           examine how household energy usage varies over a 2-day 
#           period in February, 2007. This will be done by generating
#           a plot to visualy compare the energy consumptions from
#           from 3 different sub meters that correspond to the different
#           areas of common households
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


Date2 <- as.Date(consumptionData$Date,format="%d/%m/%Y")
consumptionData$Time2 <- strptime(paste(consumptionData$Date,consumptionData$Time),format="%d/%m/%Y %H:%M:%S")
setwd(initialDir)

#Set plot global variables
par(mfcol=c(1,1))
par(mar=c(5,4,4,1))
par(cex=.8)

#Generate plot to sceen
with(consumptionData, {
  plot(Time2, Sub_metering_1
       ,type="l"
       ,ylab="Energy sub metering"
       ,xlab="")
  points(Time2, Sub_metering_2
         ,type="l"
         ,col="Red")
  points(Time2, Sub_metering_3
         ,type="l"
         ,col="Blue")
  legend("topright"
         ,pch = NA
         ,col = c("Black", "Red", "Blue")
         ,lwd=0.5
         ,legend=c("Sub_metering_1             ","Sub_metering_2  ","Sub_metering_3  ")
         #,box.lwd=0
         #,x = .1
         )
})

# The png device uses 480x480 pixels by default according to:
# https://stat.ethz.ch/R-manual/R-devel/library/grDevices/html/png.html
# I verified this once the files were created.
dev.copy(png, file = "plot3.png")
dev.off()
