## Getting data ## 
library(xlsx)

# https://docs.unocha.org/sites/dms/Documents/WHDT%202013%20Data.zip

x <- read.xlsx('data/WHDT Time Series Data.xlsx', 
          sheetIndex = 1, 
          startRow = 1, 
          endRow = 2,
          colIndex = 3:10, 
          header = FALSE)

