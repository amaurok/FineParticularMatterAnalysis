#Download the data set, and unzip it.
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
path <- getwd()
if(!file.exists(path)){ 
  dir.create(path)
}
fileName <- "DataNEI.zip"
download.file(url, file.path(path, fileName))
unzip(fileName)

#Read the required datasets.
NEI <- readRDS("summarySCC_PM25.rds")
SCCData <- readRDS("Source_Classification_Code.rds")

#Grep the scc data, to get only the short names containing coal.
coalData <- grep("coal",SCCData$Short.Name,value=T,ignore.case=T)
#Get a subset of the scc data, for all the short names containing coal.
SCC.CC <- subset(SCCData, SCCData$Short.Name %in% coalData, select=SCC)
#Get the subset with the emisions data, for the  coal combustion-related sources.
coalData <- subset(NEI, NEI$SCC %in% SCC.CC$SCC)

#Aggregate the data by year, for all the coal combustion-related sources, across the USA.
coalEmissions <- aggregate(coalData$Emissions, by = list(coalData$year), FUN = "sum")
names(coalEmissions) <- make.names(c("year","total"),unique = TRUE)

#Create a bar plot to answer the question.
barplot(coalEmissions$total, names.arg=coalEmissions$year, 
        main=expression('Total PM2.5 Coal Combustion Emissions in the US By Year'),
        xlab='Year', ylab=expression('Total Emissions'))
dev.copy(png, file="plot4.png", height=480, width=600)
dev.off()
