
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
         Sex = str_sub(Sex,1,1),
         Tag_Type = "Acoustic",
         Manufacturer = "Vemco",
         Implant_type = "Internal",
         Method = "",
         Activation = "",
         Tag_Life = 3650,
         Owner = "Bradley Peterson",
         Ogranization = "Stony Brook Universtiy",
         Scientific_Name = "",
         Cap_Lat = "",
         Cap_Lon = "", 
         Wild = "W",
         Stock = "Atlantic",
         Weight = "",
         Length_type = "TOTAL",
         length2 = "",
         LENGTH_TYPE2 = "",
         Life_stage = "",
         age = "",
         age_unit = "",
         dna = "Y",
         treatment_type = "",
         release_group = "",
         time_zone = "UTC") %>% 
  select(`Field ID`,Tag_Type,Manufacturer, `Acoustic Serial Number`, Code_ID, CodeSpace, 
         Implant_type, Method, Activation, Tag_Life, Tagger, Owner, Ogranization, Species, 
         Scientific_Name, Location, Cap_Lat, Cap_Lon, Wild, Stock, TL, Weight, Length_type,
         length2, LENGTH_TYPE2, Life_stage, age, age_unit, Sex, dna, treatment_type, release_group,
         Location, y, x, Hooked, time_zone) %>% 
  write_csv("matos_tagupdate.csv")

