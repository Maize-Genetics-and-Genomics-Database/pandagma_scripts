library(dplyr)
library(purrr)
library(tibble)
library(tidyr)
library(readr)

multmerge = function(mypath){
  cat("working directory:", mypath)
  filenames = list.files(path=mypath, full.names=TRUE)
  print(filenames)
  datalist = lapply(filenames, function(x){read.csv(file=x,header=T)})
  print("Data list built")
  Reduce(function(x,y) {merge(x,y,all = TRUE)}, datalist)
}
table_ibd = multmerge("pandagma_csv")

print("Write to table pandagma_table.txt")
write.table(table_ibd, file = "pandagma_table.txt", quote = FALSE, sep = "\t", row.names = F)

