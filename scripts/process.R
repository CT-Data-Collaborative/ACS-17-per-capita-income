library(tidyr)
source("./scripts/utils.R")

#Setup environment
sub_folders <- list.files()
raw_location <- grep("raw", sub_folders, value=T)
path_to_raw <- (paste0(getwd(), "/", raw_location))
raw_data <- dir(path_to_raw, recursive=T, pattern = "B19301_with_ann", full.names = TRUE)

# extract information and write to CSV file
ct.income<- getCTPerCapitaIncome(raw_data)
counties <- getGatheredCountyData(ct.income)
towns    <- getGatheredTownData(ct.income)

WriteDFToTable(counties, "per-capita-income-by-county-ACS_2017.csv")
WriteDFToTable(towns, "per-capita-income-by-town-ACS_2017.csv")
