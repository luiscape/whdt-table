## Method 1: fetch data from the HDX Repository. ##
#
# The HDX repository contains around 38% of the dataset
# used in the World Humanitarian Data & Trends publication. 
# This method fetches the data from the HDX repository and 
# stores a final table. 
#
# The method still needs improvement to be able to search
# and automatically find the most appropriate dataset from 
# a search query. 
#
#

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
    
    if (name %in% dbListTables(db) == FALSE) {
        dbWriteTable(db, paste0("'",name,"'"), y, row.names = FALSE, overwrite = TRUE)
    }
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
    x <- dbReadTable(db, paste("'", name, "'", sep = ""))
    
    # Exctracts only the latest year.
    ind_prob <- 'Impact of natural disasters: population affected (average per year-million)'
    if (url_list$indicator[i] == ind_prob) y <- x[, 1:2]
    else y <- x[, 1:3]
    y$Country_name <- NULL
    
    if (url_list$indicator[i] == ind_prob) { 
        colnames(y)[2] <- paste(name, "(2013)") 
    }
    else { 
        colnames(y)[2] <- paste0(name, " (", 
                                 gsub("X", "", colnames(y)[2]),
                                 ")")
    }
    
    # Assembles the final table.
    if (i == 1) { method1_table <<- y }
    else { method1_table <<- merge(method1_table, y, by = "Country_code",
                                 all = TRUE) 
    }
    dbDisconnect(db)  
} 
