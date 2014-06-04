 ## Merging script. 
# 
# Script to merge the output of all the methods. 

source('method_1.R')  # Method 1 collects data from HDX Repo.
source('method_2.R')  # Method 2 collects data from the World Bank API.
source('method_3.R')  # Method 3 pulls data from a local folder.

final_table <- merge(method1_table, method2_table, by = "iso3", all = TRUE)
final_table <- merge(final_table, method3_table, by = "iso3", all = TRUE)

final_table$iso2 <- NULL

dir.create('final_table')
write.csv(final_table, file = "final_table/final_table.csv", row.names = F)
