## Method 3: fetch data manually. 
#
# This method fetches data manually.
#

library(RCurl)
library(hdxdictionary)

# Loading data downloaded manually. 
gha_data <- read.csv('indicator_data/Humanitarian funding received.csv')

# Work-around because the dictionary isn't working properly.
gha_data$iso2 <- hdxdictionary(gha_data$Year, 'country.name', 'iso2c', )
gha_data$iso3 <- hdxdictionary(gha_data$iso2, 'iso2c', 'iso3c')
gha_data$iso2 <- NULL

# Selecting the last year 
latest_year <- as.numeric(gsub("X", "", names(gha_data)))
latest_year <- sort(latest_year)[length(na.omit(latest_year))]

# Selecting data from the latest year. 
latest_year_data <- data.frame(gha_data$Year, gha_data$iso3, gha_data$X2011)
latest_year_data <- data.frame(latest_year_data[2:nrow(latest_year_data), ], row.names = NULL)

# Edit the missing countries in Excel manually. 
write.csv(latest_year_data, 'test.csv', row.names = F)

# Re-load into R. 
latest_year_data <- read.csv('test.csv')

# Renaming it properly. 
names(latest_year_data) <- c('country_name', 'iso3', 
                             paste0('Humanitarian funding received', " (", latest_year, ")"))

latest_year_data$country_name <- NULL

# Assembling the method 3 table.
method3_table <- latest_year_data

