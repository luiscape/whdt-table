 ## Merging script. 
# 
# Script to merge the output of all the methods. 

source('method_1.R')
source('method_2.R')
source('method_3.R')

final_table <- merge(method1_table, method2_table, by = "iso3")
final_table <- merge(final_table, method3_table, by = "iso3")

final_table$iso2 <- NULL

dir.create('final_table')
write.csv(final_table, file = "final_table/final_table.csv", row.names = F)