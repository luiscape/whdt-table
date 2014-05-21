library(xlsx)
library(countrycode)

## Creating the indicator list. ##

# Loading data.
data <- read.xlsx('data/WHDT 2013 Selected Indicators.xlsx', 
          sheetIndex = 1,  
          startRow = 1,
          endRow = 3, 
          header = FALSE)

data <- data.frame(t(data), row.names = NULL)
indicator_list <- data.frame(data[2:22, ], row.names = NULL)

# Adding names to the columns. 
names_correct <- c('indicator', 'source', 'period')
names(indicator_list) <- names_correct

# Writing CSV of the list.
dir.create('table')
write.csv(indicator_list, 'table/list_of_indicators.csv', row.names = F)


## Creating the country list. ## 
data <- read.xlsx('data/WHDT 2013 Selected Indicators.xlsx', 
                  sheetIndex = 1,  
                  startRow = 3,
                  header = TRUE)

country_list <- data.frame(data$Country)

country_list$iso3 <- hdxdictionary(country_list$data.Country, 'country.name', 'iso2c')
country_list$iso3 <- hdxdictionary(country_list$iso3, 'iso2c', 'iso3c')

names(country_list) <- c('country_name', 'iso3')
dir.create('table')
write.csv(country_list, 'table/list_of_countries.csv', row.names = F)  # a couple need manual add.