library(lubridate)
library(dplyr)

if (!file.exists('household_power_consumption.txt')){
  temp <- tempfile()
  download.file('https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip', 
                temp)
  unzip(temp)
  remove(temp)
}

power <- read.delim('household_power_consumption.txt', sep = ';', header = T)
power['DateTime'] <- paste(power$Date, power$Time, sep = ' ') 
power$DateTime <- strptime(power$DateTime, '%d/%m/%Y %H:%M:%S', tz = '')

power <- filter(power, year(power$DateTime) == 2007 & month(power$DateTime) == 2)
power <- filter(power, day(power$DateTime) == 1 | day(power$DateTime) == 2)

power$Global_active_power <- as.numeric(power$Global_active_power)

png(file = 'plot2.png', width = 480, height = 480, units = "px", pointsize = 12)
plot(power$DateTime, power$Global_active_power, 
     type = 'l',
     main = '', 
     xlab = '', 
     ylab = 'Global Active Power (kilowatts)')
dev.off()