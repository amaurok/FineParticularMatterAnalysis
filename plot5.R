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

#Grep the scc data, to get only the short names containing motor vehicles sources.
#Note: By examining the SCC categories by different criterias ("motor vehicle","vehicle","motor"), 
#the grep by "vehicle" returns the better data and more information, to perform the analysis.
motorVehicleCategories <- grep("vehicle",SCCData$EI.Sector,value=T,ignore.case=T)
#Get a subset of the scc data, for all the short names containing motor vehicles sources.
SCC.CC <- subset(SCCData, SCCData$EI.Sector %in% motorVehicleCategories, select=SCC)
#Get the subset with the emisions data, for the  motor vehicles sources.
motorVehicleData <- subset(NEI, NEI$SCC %in% SCC.CC$SCC & NEI$fips=="24510" )

#Aggregate the data by year, for all the coal combustion-related sources, across the USA.
motorVehicleEmissions <- aggregate(motorVehicleData$Emissions, by = list(motorVehicleData$year), FUN = "sum")
names(motorVehicleEmissions) <- make.names(c("year","total"),unique = TRUE)

#Create a bar plot to answer the question.
barplot(motorVehicleEmissions$total, names.arg=motorVehicleEmissions$year, 
        main=expression('Total PM2.5 Motor Vehicle Sources Emissions in Baltimore City'),
        xlab='Year', ylab=expression('Total Emissions'))
dev.copy(png, file="plot5.png", height=480, width=600)
dev.off()