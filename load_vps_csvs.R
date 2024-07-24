
#' Combine exported csvs from vps analysis into a 
#' dataframe with proper column formatting
#' 
#' @param is the file that contains the subdirectories.
#' @returns A dataframe.
#' @examples
#' load_vps_files()

load_vps_files <- function() {
  
  library(tidyverse)
  library(lubridate)
  library(utils)
  library(progress)
  
  
  format <- cols( 
    `...1` = col_double(),
    `SIndex` = col_double(),
    `FullId` = col_character(),
    `Station` = col_character(),
    `Time` =col_datetime(format = ""),
    `X` = col_double(),
    `Y` = col_double(),
    `Z` = col_double(),
    `HPEs` = col_double(),
    `HPEm` = col_double(),
    `RMSE` = col_double(),
    `SensorValue` = col_double(),
    `SensorUnit` = col_double(),
    `nBasic` = col_double(),
    `RxDetected` = col_character(),
    `RxUsed` = col_character(),
    `nRxUsed` = col_double(),
    `Longitude` = col_double(),
    `Latitude` = col_double()
  )

    

    # Initialize an empty list to store data frames
    all_data_frames <- list()
    

      # Get a list of all files in the subdirectory
      files <- list.files(path = "detection_files", pattern = "\\.csv$", recursive = TRUE, full.names = TRUE)
      
      pb <- progress_bar$new(total = length(files))
      # Loop through each file and read it into a data frame
      for (file in files) {
  
        # Example assuming CSV format
        data <-  suppressMessages(suppressWarnings(read_csv(file, col_types = format)))
        
        # Append the data frame to the list
        all_data_frames[[length(all_data_frames) + 1]] <- data
        
        pb$tick()
       
      }

    
    # Combine all data frames into a single data frame
    combined_data <- do.call(rbind, all_data_frames)
    
    return(combined_data)
  }

