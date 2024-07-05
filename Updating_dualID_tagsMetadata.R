
# Updating MATOS ----------------------------------------------------------
## Code for pulling dual sensor tag info
library(readxl)
library(tidyverse)

# Set working directory to where you have dumped the download of zipped files
setwd("/Users/brittneyscannell/Desktop")


# Bind all tagging metadata together
tags <- tibble()
files <- list.files('.', full.names = TRUE, recursive = TRUE, pattern = "tag", ignore.case = TRUE)

for (tag_file in files) {
  print(tag_file)
  temp_file <- suppressMessages(suppressWarnings(read_excel(tag_file, sheet = 2)))
  tags <- bind_rows(tags, temp_file)
}


# Pull in file of tags that need to be added
sn <- read_excel("/Users/brittneyscannell/Desktop/Shark_Capture.xlsx") %>%
  pull(`Acoustic Serial Number`)


tags %>% 
  filter(`Serial No.` %in% sn) %>% 
  write_csv("tag_update.csv")


