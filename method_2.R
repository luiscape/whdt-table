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

# UNDP.HDI.XD -- Human development index. 
# NY.GDP.MKTP.KD.ZG -- GDP growth (annual %)
# SP.POP.DDAY.TO -- Number of people living on less than $1.25 a day (PPP)
# SH.STA.MALN.ZS -- "Malnutrition prevalence, weight for age (% of children under 5)"
# SH.STA.STNT.ZS -- "Malnutrition prevalence, height for age (% of children under 5)"  
# SP.DYN.LE00.IN -- Life expectancy at birth, total (years)
# "SH.MED.PHYS.ZS" "Physicians (per 1,000 people)" 
# "IT.CEL.SETS.P2" -- "Mobile cellular subscriptions (per 100 people)" 
