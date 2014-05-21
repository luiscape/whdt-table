## Fetch Data ## 


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

