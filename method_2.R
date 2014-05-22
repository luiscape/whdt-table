## Method 2: fetch data from the WDI package.
#
# This method look at the WorldBank API for the best
# dataset using the WDI package. It then queries the API 
# for the dataset of interest using the country-list of the 
# publication. 
# 
# This method fetches most of the remaining datasets. The
# rest will be fecthed manually.
#

library(WDI)
library(hdxdictionary)

## List of indicators fetched. 
# UNDP.HDI.XD -- Human development index. 
# NY.GDP.MKTP.KD.ZG -- GDP growth (annual %)
### SI.POV.DDAY -- Poverty headcount ratio at $1.25 a day (PPP) (% of population)
# SH.STA.MALN.ZS -- "Malnutrition prevalence, weight for age (% of children under 5)
# SP.DYN.LE00.IN -- Life expectancy at birth, total (years)
# SH.MED.PHYS.ZS -- Physicians (per 1,000 people)
# IT.CEL.SETS.P2 -- Mobile cellular subscriptions (per 100 people)

# Fetchig the country list.
country_list <- read.csv('table/list_of_countries.csv')
iso2 <- country_list$iso2

# Fetching the indicator list. 
indicator_list  <- read.csv('table/list_of_indicators.csv')
wb_indicators <- subset(indicator_list, (is_worldbank != FALSE))
wb_indicators <- wb_indicators$is_worldbank

for(i in 1:length(wb_indicators)) { 
    
    # Fetching the data.
    name <- WDIsearch(wb_indicators[i], field = "indicator")

        x <- WDI(iso2, wb_indicators[i]) 
        latest_year <- x$year[1]
        
        x <- subset(x, (year == latest_year))
        x$year <- NULL
        x$country <- NULL
        
        # Naming.
        colnames(x)[2] <- paste0(as.character(name[2]), " (", latest_year, ")")
        
        # Merging data.frame.
        if (i == 1) { method2_table <<- x }
        else { method2_table <<- merge(method2_table, x, by = "iso2c", all = TRUE) }
} 

colnames(method1_table)[1] <- 'iso3'
colnames(method2_table)[1] <- 'iso2'

method2_table <- merge(method2_table, country_list, by = "iso2")