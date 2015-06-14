#Download the data set, and unzip it.
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
path <- getwd()
if(!file.exists(path)){ 
  dir.create(path)
}
fileName <- "DataNEI.zip"
download.file(url, file.path(path, fileName))
unzip(fileName)

#Load the library to create the plot.
library(ggplot2)

#Read the required dataset.
NEI <- readRDS("summarySCC_PM25.rds")

#Get a subset, containing only the data for Baltimore (fips=="24510").
neiBaltimore <-subset(NEI,fips=="24510")

#Create a data frame, aggregating the total of emissions by year and source, for Baltimore.
emissionsByYearAndSource <- aggregate(neiBaltimore$Emissions, by = list(neiBaltimore$year,neiBaltimore$type), FUN = "sum")
names(emissionsByYearAndSource) <- make.names(c("year","type","total"),unique = TRUE)

#Question:Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
#which of these four sources have seen decreases in emissions from 1999-2008 for Baltimore City?

#Create the plot to answer the question, and save it to the working directory.
png('plot3.png', width=600, height=480)
p <- ggplot(emissionsByYearAndSource, aes(year, total, color = type)) + geom_line() +
  xlab("year") +
  ylab(expression('Total PM2.5 Emissions')) +
  ggtitle('Total Emissions in Baltimore City, Maryland from 1999 to 2008 By Type Of Source')
print(p)
#Assign the output of dev.off to a variable, in order to avoid the warning message of namespace, when closing
# the device.
garbage <- dev.off()