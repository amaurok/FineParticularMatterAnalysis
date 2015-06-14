#Download the data set, and unzip it.
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
path <- getwd()
if(!file.exists(path)){ 
  dir.create(path)
}
fileName <- "DataNEI.zip"
download.file(url, file.path(path, fileName))
unzip(fileName)

#Read the required dataset.
NEI <- readRDS("summarySCC_PM25.rds")
#Get a subset, containing only the data for Baltimore (fips=="24510").
neiBaltimore <-subset(NEI,fips=="24510")

#Create a data frame, aggregating the total of emissions from all sources, by year for Baltimore.
totalEmissions <- aggregate(neiBaltimore$Emissions, by = list(neiBaltimore$year), FUN = "sum")
names(totalEmissions) <- make.names(c("year","total"),unique = TRUE)

#Question to answer:
#Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008?

#Create a bar plot to answer the question.
barplot(totalEmissions$total, names.arg=totalEmissions$year, 
        main=expression('Total Emissions of PM2.5 in Baltimore City, Maryland'),
        xlab='Year', ylab=expression('Total Emissions'))
dev.copy(png, file="plot2.png", height=480, width=480)
dev.off()

