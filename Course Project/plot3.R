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

power$Sub_metering_1 <- as.numeric(power$Sub_metering_1)
power$Sub_metering_2 <- as.numeric(power$Sub_metering_2)
power$Sub_metering_3 <- as.numeric(power$Sub_metering_3)

png(file = 'plot3.png', width = 480, height = 480, units = "px", pointsize = 12)
plot(power$DateTime, power$Sub_metering_1, type = 'l', 
     xlab = '', ylab = 'Energy sub metering')
lines(power$DateTime, power$Sub_metering_2, col = 'red', type = 'l')
lines(power$DateTime, power$Sub_metering_3, col = 'blue', type = 'l')
legend(x = 'topright',
       legend=c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'), 
       col=c('black', 'red', 'blue'), 
       text.col = 'black', 
       lty=c('solid', 'solid', 'solid'), 
       ncol=1)     

dev.off()