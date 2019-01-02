library(tidyr)
source("./scripts/utils.R")

#Setup environment
sub_folders <- list.files()
raw_location <- grep("raw", sub_folders, value=T)
path_to_raw <- (paste0(getwd(), "/", raw_location))
raw_data <- dir(path_to_raw, recursive=T, pattern = "B19013_with_ann", full.names = TRUE)

# extract information and write to CSV file
ct.income<- getCTHouseholdIncome(raw_data)
counties <- getGatheredCountyData(ct.income)
towns    <- getGatheredTownData(ct.income)

WriteDFToTable(counties, "median-household-income-by-county-ACS_2017.csv")
WriteDFToTable(towns, "median-household-income-by-town-ACS_2017.csv")
