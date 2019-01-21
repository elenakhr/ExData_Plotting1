library(dplyr)
library(stringr)
library(lubridate)

#Check if File exists and douload if it doesn't
if(!file.exists("household_power_consumption.txt")){
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", destfile = "data.zip")
unzip("data.zip")
}

# Read data
a <- read.table("household_power_consumption.txt", sep=";", stringsAsFactors = FALSE, header = T)
a<-tbl_df(a)

# Subset required values
b <- subset(a, Date=="1/2/2007"|Date=="2/2/2007")

# Convert the first two variables into date
bb<-b %>% mutate(DateTime = dmy_hms(paste(Date,Time)), WeekDay=wday(DateTime, label = TRUE))

# Renew Graphic device:
# Renew Graphic device:
if(dev.cur() > 1){
	dev.off()
}

# Convert all other variables into numeric values
bb$Global_active_power <-as.numeric(bb$Global_active_power)
bb$Global_reactive_power<-as.numeric(bb$Global_reactive_power)
bb$Voltage <-as.numeric(bb$Voltage)
bb$Global_intensity <-as.numeric(bb$Global_intensity)
bb$Sub_metering_1 <- as.numeric(bb$Sub_metering_1)
bb$Sub_metering_2 <- as.numeric(bb$Sub_metering_2)
bb$Sub_metering_3 <- as.numeric(bb$Sub_metering_3)

# Create plot #3 and write it into the file
with(bb,plot(DateTime, Sub_metering_1, ylab="Energy Sub Metering", xlab="", type="l"))
with(bb, lines(DateTime,Sub_metering_2, col="red"))
with(bb, lines(DateTime, Sub_metering_3, col="blue"))
legend("topright", lwd=c(1,1,1), cex=0.7, bty="o", 
       col=c("black", "red", "blue"), 
       text.width=strwidth("Sub_metering_1"),
       legend=c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"))
dev.copy(png, file="plot3.png")
dev.off()
