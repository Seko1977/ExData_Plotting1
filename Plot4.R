
###########################################################################
#Course 4 Explonatory Data Week 1 Project Assignment
############################################################################

###Requirements:
# Our overall goal here is simply to examine how household energy usage varies over 
# a 2-day period in February, 2007. The task is to reconstruct the some plots  specified 
# in the assignment, all of which were constructed using the base plotting system.
# Construct the plot and save it to a PNG file with a width of 480 pixels and a height 
# of 480 pixels.
# Name each of the plot files as plot1.png, plot2.png, etc.

##########################################################################
# Setting working directory and downloading the data
#########################################################################

# get and set the working directory
getwd()
setwd("C:/Users/s.fazlioglu/Dropbox/Coursera/Course4_exploratory_data")

# getting necessary packages
library(RCurl)
library(dplyr)
library(lubridate)
library(data.table)
library(ggplot2)
library(lattice)

# download the file an place it into the folder
if(!file.exists("data")){dir.create("data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="libcurl")

# unzip the file
unzip(zipfile="./data/Dataset.zip", exdir="./data")

# get the list of files an rename the file
list.files("./data", recursive=TRUE)
file.rename("./data/household_power_consumption.txt","./data/Energy.txt")

##################################################
# Downloading the data
#################################################
# 1.The dataset has 2,075,259 rows and 9 columns. First calculate a rough estimate of how much
# memory the dataset will require in memory before reading into R. Make sure your computer has 
# enough memory (most modern computers should be fine).

# 2. We will only be using data from the dates 2007-02-01 and 2007-02-02. 
# One alternative is to read the data from just those dates rather than reading in the entire dataset 
# and subsetting to those dates.

# 3.You may find it useful to convert the Date and Time variables to Date/Time classes in R 
#using the strptime()  and as.Date() functions.

# 4. Note that in this dataset missing values are coded as ?.
#################################################

#downloading the data- specify the missing values and strings as factors
###########
Energy<- read.table("./data/Energy.txt", header=TRUE, sep=";", stringsAsFactors=FALSE, 
                    na.strings = c("?"))
str(Energy)
# Subsetting the data
subEnergy <- Energy[Energy$Date %in% c("1/2/2007","2/2/2007") ,]

# removing the files 
file.remove("./data/Dataset.zip")
file.remove("./data/Energy.txt")
rm(Energy)

# convert the date variable to Date class
subEnergy$Date <- as.Date(subEnergy$Date, format = "%d/%m/%Y")

# Convert dates and times
subEnergy$datetime <- strptime(paste(subEnergy$Date, subEnergy$Time), "%Y-%m-%d %H:%M:%S")
head(subEnergy$Date)

######################################################
# Plot 4
######################################################

subEnergy$datetime <- as.POSIXct(subEnergy$datetime)

# 4 figures arranged in 2 rows and 2 columns
attach(subEnergy)
par(mfrow=c(2,2))
plot(Global_active_power ~ datetime, type = "l",
     ylab = "Global Active Power (kilowatts)", xlab = "")

plot(Voltage ~ datetime, type = "l",
     ylab = "Voltage", xlab = "datetime")

plot(Sub_metering_1 ~ datetime, type = "l", 
     ylab = "Energy sub metering", xlab = "")
lines(Sub_metering_2 ~ datetime, col = "Red")
lines(Sub_metering_3 ~ datetime, col = "Blue")
legend("topright", lty, bty="n", col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

plot(Global_reactive_power ~ datetime, type = "l",
     ylab = "Global_reactive_power", xlab = "datetime")

dev.copy(png, file = "plot4.png", height = 480, width = 480)
dev.off()

detach(subEnergy)
