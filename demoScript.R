install.packages(c("ggplot2", "rvest", "XML", "dplyr", "stringr"))
library(ggplot2)
library(dplyr)
library(stringr)
library(rvest)
library(XML)

#Import data from internet by web scraping
projectTable <- read_html("https://www.lacoast.gov/new/Projects/List.aspx")

#goes from list of 2 to list of 1 (in Environment window)
fullTable <- projectTable %>% html_table(fill = TRUE)

#use double square brackets to specify which table from web page (i.e., fullTable)
table1 <- fullTable[[1]]

# filter table1 to only include demonstration projects
tableDemos <- table1[str_detect(table1$`Project Types`, "Demonstration"), ]

# convert character type to numeric
mystery_char <- substr(tableDemos$`Approved Estimate`[1], 1, 1)
charToRaw(mystery_char)
str_replace_all(tableDemos$`Approved Estimate`, rawToChar(as.raw(c(0x31))), '')

tableDemos$estNum <- gsub(",", "", tableDemos$`Approved Estimate`) #used gsub to replace commas in Approved Estimate column
tableDemos_num <- as.numeric(tableDemos$estNum)
hist(tableDemos_num, main = "Histogram of Demonstration Projects Grouped by Price", xlab = "Price", labels = TRUE)
hist(tableDemos_num, plot = FALSE)

#tableDemos$estNum <- as.numeric(gsub(",", "", str_replace_all(tableDemos$`Approved Estimate`, rawToChar(as.raw(c(0x31))), '')))
#hist(tableDemos$estNum, breaks = 10, main = "Histogram of Demonstration Projects by Price", xlab = "Price") ***loses project in $3M range

ggplot(tableDemos, aes(x = PPL, y = estNum)) +
  geom_point(aes(color = factor(Agency))) +
  labs(title = 'Cost of Demonstration Projects for Each PPL', y = 'Cost (Millions of Dollars)')
