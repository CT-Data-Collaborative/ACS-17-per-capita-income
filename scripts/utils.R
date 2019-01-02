ToNumeric <- function (factor) {
  return(as.numeric(as.character(factor)))
}

ExtractNumData <- function (factor) {
  return(ToNumeric(factor[1:length(factor)]))
}

WriteDFToTable <- function(df, filename){
  write.table(
    df,
    file = file.path(getwd(), "data", filename),
    sep = ",",
    row.names = FALSE
  )
}

# Read Connecticut-specific CSV for median household income
getCTPerCapitaIncome <- function(filepath){
  ct.data  <- read.csv(filepath, header = FALSE)
  ct.data <- ct.data[-1:-2,]
  names(ct.data) <- c("Id", "FIPS", "Geography", "Per Capita Income", "MoE")
  
  ct.data$Year <- rep("2013-2017", length(ct.data[,1]))
  ct.data <- ct.data[!(grepl("not defined", ct.data$Geography)),]
  return(ct.data)
}

# group moe and income under single observational unit
gatherEstimateMoE <- function(ct.income){
  ct.income <- ct.income[,c(1,2,3,5,6,4)]
  return(
    ct.income %>%
      gather("Variable", "Value", c("Per Capita Income","MoE"))
  )
}

# Sort data by FIPS Code
orderedByGeography <- function(ct.income){
  return(ct.income[order(ct.income[,2], ct.income[,3]),])
}


getGatheredCountyData <- function(ct.income){
  ct.income$Geography <- gsub(", Connecticut", "", ct.income$Geography)
  gathered <- gatherEstimateMoE(ct.income[ExtractNumData(ct.income$FIPS) < 10000,])
  return(orderedByGeography(gathered))
}

getGatheredTownData <- function(ct.income){
  ct.income$Geography <- gsub(",.*, Connecticut", "", ct.income$Geography)
  gathered<- gatherEstimateMoE(ct.income[grepl("(^Connecticut$)|town", ct.income$Geography),])
  return(orderedByGeography(gathered))
}
