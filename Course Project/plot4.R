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

power$Voltage <- as.numeric(power$Voltage)

power$Global_reactive_power <- as.numeric(power$Global_reactive_power)

power$Sub_metering_1 <- as.numeric(power$Sub_metering_1)
power$Sub_metering_2 <- as.numeric(power$Sub_metering_2)
power$Sub_metering_3 <- as.numeric(power$Sub_metering_3)

png(file = 'plot4.png', width = 480, height = 480, units = "px", pointsize = 12)
par(mfcol = c(2,2))
# plot2
plot(power$DateTime, power$Global_active_power, 
     type = 'l',
     main = '', 
     xlab = '', 
     ylab = 'Global Active Power (kilowatts)')

#plot3
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

# new plot: Voltage
plot(power$DateTime, power$Voltage, type = 'l', 
     xlab = 'datetime', 
     ylab = 'Voltage')

# new plot: Global_reactive_power
plot(power$DateTime, power$Global_reactive_power, type = 'l', 
     xlab = 'datetime', 
     ylab = 'Global_reactive_power')

dev.off()