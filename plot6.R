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
marylandData <- subset(NEI, NEI$SCC %in% SCC.CC$SCC & NEI$fips=="24510" )
californiaData <- subset(NEI, NEI$SCC %in% SCC.CC$SCC & NEI$fips=="06037" )


#Aggregate the data by year, for all the coal combustion-related sources for Baltimore Maryland.
mdMotorVehicleEmissions <- aggregate(marylandData$Emissions, by = list(marylandData$year), FUN = "sum")
names(mdMotorVehicleEmissions) <- make.names(c("year","total"),unique = TRUE)
mdMotorVehicleEmissions$City <- "Baltimore"

#Aggregate the data by year, for all the coal combustion-related sources for Los Angeles - California.
caMotorVehicleEmissions  <- aggregate(californiaData$Emissions, by = list(californiaData$year), FUN = "sum")
names(caMotorVehicleEmissions) <- make.names(c("year","total"),unique = TRUE)
caMotorVehicleEmissions$City <- "Los Angeles"

#Rbind the data frames for the two cities.
finalDataSet <- as.data.frame(rbind(mdMotorVehicleEmissions, caMotorVehicleEmissions))

#Load the library to create the plot.
library(ggplot2)

#Create the plot to answer the question, and save it to the working directory.
png('plot6.png', width=600, height=480)
ggplot(finalDataSet,aes(x=as.factor(year),y=total,fill=factor(City))) +
  geom_bar(stat="identity",position="dodge") +
  xlab("Year")+ylab("Total") +
  ggtitle('Total Emissions of Motor Vehicle Sources\nLos Angeles, California vs. Baltimore City, Maryland')

#Assign the output of dev.off to a variable, in order to avoid the warning message of namespace, when closing
# the device.
garbage <- dev.off()