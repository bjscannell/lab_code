
# Updating MATOS ----------------------------------------------------------
## Code for pulling dual sensor tag info
library(readxl)
library(tidyverse)
library(lubridate)

# Set working directory to where you have dumped the download of zipped files
setwd("/Users/brittneyscannell/Desktop")


# Bind all tagging metadata together
tags <- tibble()
files <- list.files('.', full.names = TRUE, recursive = TRUE, pattern = "tagsheet", ignore.case = TRUE)

for (tag_file in files) {
  print(tag_file)
  temp_file <- suppressMessages(suppressWarnings(read_excel(tag_file, sheet = 2)))
  tags <- bind_rows(tags, temp_file)
}


# Pull in file of tags that need to be added
sharks <- read_csv("/Users/brittneyscannell/Desktop/Shark_Capture.csv",
  col_types = cols(`Acoustic Serial Number` = col_character(),
                 `Hooked` = col_datetime(format = "%m/%d/%Y %I:%M:%S %p")))
sn <- sharks %>%
  pull(`Acoustic Serial Number`)

# Join with shark info
## Don't forget everythings in fucking UTC
sharks %>% left_join(tags, by = c("Acoustic Serial Number" = "Serial No.")) %>% 
  mutate(Code_ID = str_sub(`VUE Tag ID`, 10),
         CodeSpace = str_sub(`VUE Tag ID`, 1,8),
         Sex = str_sub(Sex,1,1)) %>% 
  select(`Field ID`,`Acoustic Serial Number`, Code_ID, CodeSpace, 
         Tagger, Species, Location,TL, FL, Sex, y, x, Hooked) %>% 
  write_csv("matos_tagupdate.csv")
