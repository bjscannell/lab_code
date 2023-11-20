
#' Combine exported csvs frome vue into a 
#' dataframe with proper column formatting
#' 
#' @param is the defining project identifier e.g. "artificial"
#' @returns A dataframe.
#' @examples
#' load_vue_files()

load_vue_files <- function(project) {
  
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
  for (detfile in intersect(list.files('.', full.names = TRUE, recursive = TRUE, pattern = "detections", ignore.case = TRUE),
                            list.files('.', full.names = TRUE, recursive = TRUE, pattern = paste(project), ignore.case = TRUE))) {
    print(detfile)
    tmp_dets <- read_csv(detfile, col_types = format)
    detections <- bind_rows(detections, tmp_dets)
  }
  
  
  return(detections)
  
}
