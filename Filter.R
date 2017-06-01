setwd("C:/Users/02418/OneDrive - Underwriters Laboratories/Project/Furniture-Pinch-Injuries/")
source("Libs/Helper_NSS.R")

# Load all data
df <- bulkLoadCSV("Assets/NSS/")
df['year'] <- extractYear(df)

# Filter data by product code
ProdList <- list(0670,0671,4016,0680,4064,1529) 
prodDf <- prodFilter(df,"prod1", "prod2", ProdList)

# filter by diagnosis
diagList <- list(50,72,54,55,57)
diagDf <- colFilter(prodDf, 'diag', diagList)

# Filter by year
YearList <- list(2010,2011,2012,2013,2014,2015)
prodYearDf <- colFilter(diagDf,'Year', YearList)


write.csv(prodYearDf, "Data-Pinch-Injuries.csv", row.names = FALSE, na = "")
