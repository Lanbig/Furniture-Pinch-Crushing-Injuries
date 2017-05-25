setwd("C:/Users/02418/OneDrive - Underwriters Laboratories/Project/Furniture-Pinch-Injuries/")
source("Libs/Helper.R")
require(stringr)

# Load all data
df <- bulkLoadCSV("Assets/NSS/")

# Filter data by product code
ProdList <- list(0670,0671,4016,0680,4064,1529) 
prodDf <- prodFilter(df,"prod1", "prod2", ProdList)
prodDf['year'] <- str_sub(prodDf[,'trmt_date'], -4) 

# filter by diagnosis
diagList <- list(50,72,54,55,57)
diagDf <- colFilter(prodDf, 'diag', diagList)

write.csv(diagDf, "Data-Pinch-Injuries.csv", row.names = FALSE, na = "")
