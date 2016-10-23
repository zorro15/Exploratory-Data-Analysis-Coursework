#START FROM HERE using setwd()
#download the zip since this is a compressed file
#unzip the file
#download the full zip then unzip
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)
unzip(temp, "household_power_consumption.txt")


#read in the txt file but only the rows you need, leave out missing values rows
household_sample <- read.table("household_power_consumption.txt",nrows=10,header=T,sep=";",na.strings="?",colClasses=NA,comment.char="")
classes <- sapply(household_sample,class)
#read the whole text
household_data <- read.table("household_power_consumption.txt",header=T,sep=";",na.strings="?",colClasses=classes,comment.char="")

unlink(temp)

#check for missing values
household_two <- read.table("household_power_consumption.txt",header=T,sep=";",na.strings="?",colClasses=NA,skip=142589,nrows=10)

#check using a subset of data what the column names are
#dimnames(household_data)
#convert the date col to the date class
household_data$Date <- as.Date(household_data$Date , "%d/%m/%Y")

#get the first day of data
household_two <- household_data[grepl("2007-02-01",household_data$Date), ]

#get the second dat of data
household_three <- household_data[grepl("2007-02-02",household_data$Date), ]

#make one dataset for both days
power_consumption <- rbind.data.frame(household_two,household_three)

#make plot2 data
weekday_power_consump <- weekdays(power_consumption$Date)
#append this to the df
plot2_data <- cbind(weekday_power_consump,power_consumption)
#make the datetime column for the y axis in plot2
dt <-as.POSIXct(paste(plot2_data$Date, plot2_data$Time, sep = " "), format="%Y-%m-%d %H:%M:%S")
plot2_data <-cbind(plot2_data,dt)

#plot 4,2 by 2
png("Plot4.png", width = 480, height = 480)
par(mfrow=c(2,2))
plot(plot2_data$dt, plot2_data$Global_active_power, type = "l", xlab = " ", ylab = "Global Active Power (kilowatts)")
plot(plot2_data$dt,plot2_data$Voltage, type ="l", xlab = "datetime", ylab = "Voltage")
library(datasets)
with(plot2_data,plot(dt,Sub_metering_1, type='n', xlab = " ", ylab = "Energy sub metering"))
points(dt,plot2_data$Sub_metering_1,type="l",col ="black")
points(dt,plot2_data$Sub_metering_2, type = "l", col = "red")
points(dt,plot2_data$Sub_metering_3, type = "l", col ="blue")
legend("topright", lwd=1, col = c("black", "red", "blue"), legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
plot(plot2_data$dt,plot2_data$Global_reactive_power, type ="l", xlab = "datetime", ylab = "Global_reative_power")
dev.off()