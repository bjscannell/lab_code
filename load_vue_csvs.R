
# this is a function that takes all your detection csvs and combines them 
# into one dataframe

load_vue_files <- function() {
  
  library(tidyverse)
  library(lubridate)
  library(utils)
  
  format <- cols( 
    `Date and Time (UTC)` = col_datetime(format = ""),
    `Receiver` = col_character(),
    `Transmitter` = col_character(),
    `Transmitter Name` = col_character(),
    `Transmitter Serial` = col_character(),
    `Sensor Value` = col_double(),
    `Sensor Unit` = col_character(),
    `Station Name` = col_character(),
    `Latitude` = col_double(),
    `Longitude` = col_double(),
    `Transmitter Type` = col_character(),
    `Sensor Precision` = col_double()
  )
  
  detections <- tibble()
  for (detfile in list.files('.', full.names = TRUE, recursive = TRUE, pattern = "Detections")) {
    print(detfile)
    tmp_dets <- read_csv(detfile, col_types = format)
    detections <- bind_rows(detections, tmp_dets)
  }
  
  
  return(detections)
  
}
