## Fetch Data ## 
# Method 1: fetch data from the HDX Repository.
library(RCurl)
library(jsonlite)
library(sqldf)

indicator_list  <- read.csv('table/list_of_indicators.csv')
url_list <- subset(indicator_list, indicator_list$is_hdx != FALSE)
url_list <- url_list[1:8,]

# Downloading all the files from HDX Repo into CSVs. 
for (i in 1:nrow(url_list)) {
    name <- as.character(url_list$indicator[i])
    down_url <- as.character(url_list$is_hdx[i])
    download.file(url = down_url, destfile = paste0("indicator_data/", name, ".csv"))
}

# Reading CSVs and storing data in a database.
for (i in 1:nrow(url_list)) {
    
    name <- as.character(url_list$indicator[i])
    x <- read.csv(as.character(url_list$is_hdx[i]))
    
    y <- subset(x, (Country.code %in% as.character(iso3_list)))
    
    db <- dbConnect(SQLite(), dbname="indicator_data/db.sqlite")
    
    dbWriteTable(db, paste0("'",name,"'"), y, row.names = FALSE, overwrite = TRUE)
    
    # for testing purposes
    # test <- dbListTables(db)
    dbDisconnect(db)
}

country_list <- read.csv('table/list_of_countries.csv')

# Creating the official list.
for (i in 1:nrow(url_list)) { 
    db <- dbConnect(SQLite(), dbname="indicator_data/db.sqlite")
    
    name <- as.character(url_list$indicator[i])
    
    # Read the table from the db.
    x <- dbReadTable(db, paste0("'", name, "'"))
    
    # Exctracts only the latest year.
    y <<- x[, 1:3]
    y$Country_name <- NULL
    colnames(y)[2] <- paste0(name, " (", 
                             gsub("X", "", colnames(y)[2]),
                             ")")
    
    # Assembles the final table.
    if (i == 1) { final_table <<- y }
    else { final_table <<- merge(final_table, y, by = "Country_code",
                                 all = TRUE) 
    }
    
    dbDisconnect(db)
    
} 






# Method 2: fetch data from the WDI package.
library(WDI)

# UNDP.HDI.XD -- Human development index. 
# NY.GDP.MKTP.KD.ZG -- GDP growth (annual %)
# SP.POP.DDAY.TO -- Number of people living on less than $1.25 a day (PPP)
# SH.STA.MALN.ZS -- "Malnutrition prevalence, weight for age (% of children under 5)"
# SH.STA.STNT.ZS -- "Malnutrition prevalence, height for age (% of children under 5)"  
# SP.DYN.LE00.IN -- Life expectancy at birth, total (years)
# "SH.MED.PHYS.ZS" "Physicians (per 1,000 people)" 
# "IT.CEL.SETS.P2" -- "Mobile cellular subscriptions (per 100 people)" 


# Method 3: fetch data from Quandl. 
library(Quandl)

x <- Quandl(authcode = quandl_key)

