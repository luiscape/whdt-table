### Method 3: fetch data manually. ###
#
# This method fetches data manually.
#

library(RCurl)
library(gdata)
library(hdxdictionary)

## GHA Data | Humanitarian Funding received (US$ million) ##
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


## UNHCR Data | Total population of concern to UNHCR ##
load_unhcr <- read.xls('indicator_data/Total population of concern to UNHCR.xls', 
         sheet = 1)
select_unhcr <- data.frame(load_unhcr$X, load_unhcr$X.20)
select_unhcr <- select_unhcr[4:198, ]
names(select_unhcr) <- c('iso3', 'Total population of concern')

# Load and merge.
list_countries <- read.csv('table/list_of_countries.csv')
select_data_unhcr <- merge(select_unhcr, list_countries, by = 'iso3')
select_data_unhcr[4] <- NULL
select_data_unhcr[3] <- NULL
names(select_data_unhcr) <- c('iso3', 'Total Population of Concern to UNHCR (2013)')

# Merging to method 3 table.
method3_table <- merge(method3_table, select_data_unhcr, by = 'iso3', all = TRUE)



## UCPD Data | Number of Last 10 Years Experiencing Active Conflict ##
load_ucpd <- read.csv('indicator_data/Number of last 10 years experiencing active conflict.csv')
load_ucpd$YEAR <- as.numeric(load_ucpd$YEAR)

# Here I am performing the calculation based on the
# data provided by UCPD. I do the calculation of 10 years
# based on counting 10 years back from the latest completed year. 
# That is, starting from 2013 = 2003.
subset_ucpd <- load_ucpd[load_ucpd$YEAR > 2003, ]
country_list <- unique(subset_ucpd$Location)
for (i in 1:length(country_list)) {
    a <- subset_ucpd[subset_ucpd$Location == as.character(country_list[i]), ]
    b <- length(unique(a$YEAR))
    if (i == 1) year_count <- b
    else year_count <- rbind(year_count, b)
}
country_list_count <- data.frame(country_list)
country_list_count$year_count <- year_count

# Adding ISO3 Codes. 
country_list_count$iso3 <- hdxdictionary(country_list_count$country_list, 
                                         'country.name', 
                                         'iso2c')

country_list_count$iso3 <- hdxdictionary(country_list_count$iso3, 
                                         'iso2c', 
                                         'iso3c')

# Work-around to fix the missing iso3 codes.
write.csv(country_list_count, file = 'temp.csv', row.names = F)
country_list_count <- read.csv('temp.csv')

# Deleting the country names column and changing names.
country_list_count[1] <- NULL
names(country_list_count) <- c('Number of last 10 years experiencing active conflict (2013)', 'iso3')

# Merging. 
method3_table <- merge(method3_table, 
                       country_list_count, 
                       by = 'iso3', 
                       all = TRUE)
