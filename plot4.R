# Purpose : The goal of this scripts is simply to 
#           examine how household energy usage varies over a 2-day 
#           period in February, 2007. This will be done by generating
#           four plots to visualy compare the energy consumptions
#           Plot 1: Global active power consumption
#           Plot 2: Global active power across time 
#           Plot 3: Energy consumptions from 3 different sub meters 
#              that correspond to the different areas of common households
#           Plot 4: Global reactive power consumption across time 
#
# Approach: 1. Download  the individual household electric power 
#              consumption Data Set.
#           2. Standardize data types
#           3. Generate plots to screen and to file
#
# Inputs:   1. URL to download the data file
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
par(mfcol=c(2,2))
par(mar=c(4,4,4,2))
par(cex=.7)
par(bg="White")

# Global active power consumption across time
with(consumptionData,
     plot(Time2, Global_active_power
          ,type="l"
          ,ylab="Global Active Power"
          ,xlab="")
)

# Global active power consumption across time
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
            ,lwd=1
            ,legend=c("Sub_metering_1               ","Sub_metering_2","Sub_metering_3")
            ,box.lwd=0
            ,bty="n")
})

# Voltage consumtion accross time
with(consumptionData,
     plot(Time2, Voltage
          ,type="l"
          ,ylab="Voltage"
          ,xlab="datetime")
)

# Global reactive power consumption across time
with(consumptionData,
     plot(Time2, Global_reactive_power
          ,type="l"
          ,ylab="Global_reactive_power"
          ,xlab="datetime")
)

# The png device uses 480x480 pixels by default according to:
# https://stat.ethz.ch/R-manual/R-devel/library/grDevices/html/png.html
# I verified this once the files were created.

dev.copy(png, file = "plot4.png")
dev.off()

