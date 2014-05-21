## Merging script. 
# 
# Script to merge the output of all the methods. 

source('method_1.R')
source('method_2.R')

colnames(method1_table)[1] <- 'iso3'
colnames(method2_table)[1] <- 'iso2'

method2_table <- merge(method2_table, country_list, by = "iso2")

final_table <- merge(method1_table, method2_table, by = "iso3", all = TRUE)

dir.create('final_table')
write.csv(final_table, file = "final_table/final_table.csv", row.names = F)