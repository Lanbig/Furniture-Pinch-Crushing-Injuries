# Author        : Ben Rodrawangpai
# Date          : 5/22/2017

require(sqldf)
require(data.table)
require(plyr)
require(stringr)
require(dplyr)

### check Colname ex: checkColname("Assets/NSS/nss",1980,2015)
checkColname <- function(fname, syear, eyear) 
{
  for( i in syear:eyear){
    name  <- paste(fname,i,".csv", sep = "")
    df    <- fread(name, header = T, sep = ',')
    print(colnames(df))
  }
}

### Load every CSV in the folder ex: df <- bulkLoadCSV("Assets/NSS/")
bulkLoadCSV <- function(pfile)  
{
  options( warn = -1 )
  
  temp = list.files(path = pfile, pattern="*.csv")
  listname  <- paste(pfile,temp, sep = "")
  df = ldply(listname, fread, header = T, sep = ',')
  
  options( warn = 1 )
  
  return(df)
}


### Filter by product code : outdf <- prodFilter(df,"prod1", "prod2", ProdList)
prodFilter <- function(df, colprod1, colprod2,listprod)
{
  #create where cause
  stm_where = "WHERE "
  for(i in listprod){
    stm_where <- paste(stm_where, colprod1 ,"== ", i, "or", colprod2 , "== ", i)
    
    if(listprod[length(listprod)] != i) # if 
      stm_where <- paste(stm_where, "or")
  }
  
 
  
  # SQL Statment  
  sql_stm = paste("SELECT * FROM ", deparse(substitute(df)) , stm_where)
  print(sql_stm)
  
  sql_df <- sqldf(sql_stm)
  
  return(sql_df)
}


### Filter by colname
colFilter <- function(df, colname, vals)
{
  stm_where = "WHERE "
  for(i in vals){
    stm_where <- paste(stm_where, colname ,"== ", i)
    
    if(vals[length(vals)] != i) # if 
      stm_where <- paste(stm_where, "or")
  }  
  
  # SQL Statment  
  sql_stm = paste("SELECT * FROM ", deparse(substitute(df)) , stm_where)
  print(sql_stm)
  
  sql_df <- sqldf(sql_stm)
  
  return(sql_df)
}

### Extract year
extractYear <- function(df , old_data = F){
  years <- str_sub(df[,'trmt_date'], -4) 
  return(years)
}

### Group Year
groupYear <- function(df){
  
  
}


merge.all <- function(x, ..., by = "year") {
  L <- list(...)
  for (i in seq_along(L)) {
    x <- merge(x, L[[i]], by = by, all.x=TRUE)
    rownames(x) <- x$Row.names
    x$Row.names <- NULL
  }
  return(x)
}