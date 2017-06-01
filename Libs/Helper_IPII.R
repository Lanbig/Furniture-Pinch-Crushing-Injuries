# Author        : Ben Rodrawangpai
# Date          : 5/30/2017

require(sqldf)
require(data.table)
require(plyr)
require(stringr)
require(dplyr)

### check Colname ex: checkColname("Assets/DEATH)
checkColname <- function(pfile) 
{
  temp = list.files(path = pfile, pattern="*.csv")
  listname  <- paste(pfile,temp, sep = "")
  
  for(name in listname){
    df <- fread(name, header = T, sep = ',')
    cat(name, ": \t")
    cat(colnames(df),"\n")  
  }
}

### Load every CSV in the folder ex: df <- bulkLoadCSV("Assets/IPII")
bulkLoadCSV <- function(pfile, old_data = T)  
{
  #1999 - 2008p 
  #2009 - 2014
  options( warn = -1 )
  
  if(missing(old_data) || old_data == F)
  {
    temp = list.files(path = pfile, pattern="*[0-9].csv")
    listname  <- paste(pfile,temp, sep = "")
    print(listname)
    df = ldply(listname, fread, header = T, sep = ',')
  }else{
    temp = list.files(path = pfile, pattern="*p.csv")
    listname  <- paste(pfile,temp, sep = "")
    print(listname)
    df = ldply(listname, fread, header = T, sep = ',')
  }
  
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
  if(missing(old_data) || old_data == F)
    years <- str_sub(df[,'dt_ent'], 1, 4)
  else{
    years <- str_sub(df[,'Date_Received'], 1, 4)
  }
  
  return(years)
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