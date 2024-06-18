library(readxl)
library(janitor)
library(dplyr)
library(lubridate)
library(ggplot2)
library(stringr)

metadata <- read_excel("NYSDEC_otn_metadata_receivers (3).xlsx", sheet = "Deployment") %>% 
  clean_names()

metadata <- read_excel("Sunrise_Orsted_otn_metadata_receivers (1).xlsx", sheet = "Deployment") %>% 
  clean_names()

metadata <- metadata %>% 
  filter(data_downloaded_y_n == "y") %>% 
  mutate(ins_serial_no = as.integer(ins_serial_no),
         deploy_date_time_yyyy_mm_dd_thh_mm_ss = ymd_hms(deploy_date_time_yyyy_mm_dd_thh_mm_ss),
         recover_date_time_yyyy_mm_dd_thh_mm_ss = ymd_hms(recover_date_time_yyyy_mm_dd_thh_mm_ss),
         midpoint = as.POSIXct((as.numeric(deploy_date_time_yyyy_mm_dd_thh_mm_ss) + as.numeric(recover_date_time_yyyy_mm_dd_thh_mm_ss)) / 2, origin = '1970-01-01')) %>% 
  group_by(station_no) %>% 
  mutate(deployment_no = as.character(row_number())) %>% ungroup()


metadata %>%  
  #filter(str_detect(station_no, 'Mor')) %>% 
  ggplot() +
  geom_segment(aes(
    x = deploy_date_time_yyyy_mm_dd_thh_mm_ss, y = station_no,
    xend = recover_date_time_yyyy_mm_dd_thh_mm_ss, yend = station_no,
    color = deployment_no),
    #color = "#aeb6bf",
    linewidth = 4.5,
    lineend='round') +
  geom_label(aes(label = ins_serial_no, x = midpoint, y = station_no)) +
  scale_color_discrete() + theme_classic()


metadata <- metadata %>% 
  #filter(data_downloaded_y_n == "y") %>% 
  mutate(ins_serial_no = as.integer(ins_serial_no),
         station = substr(station_no, start = 1, stop = 4),
         deploy_date_time_yyyy_mm_dd_thh_mm_ss = ymd_hms(deploy_date_time_yyyy_mm_dd_thh_mm_ss),
         recover_date_time_yyyy_mm_dd_thh_mm_ss = ymd_hms(recover_date_time_yyyy_mm_dd_thh_mm_ss),
         midpoint = as.POSIXct((as.numeric(deploy_date_time_yyyy_mm_dd_thh_mm_ss) + as.numeric(recover_date_time_yyyy_mm_dd_thh_mm_ss)) / 2, origin = '1970-01-01')) %>% 
  group_by(station) %>% 
  mutate(deployment_no = as.character(row_number())) %>% ungroup()

#filter(str_detect(station_no, 'Mor')) %>% 
ggplot() +
  geom_segment(metadata %>% filter(), aes(
    x = deploy_date_time_yyyy_mm_dd_thh_mm_ss, y = station,
    xend = recover_date_time_yyyy_mm_dd_thh_mm_ss, yend = station,
    color = deployment_no),
    #color = "#aeb6bf",
    linewidth = 4.5,
    lineend='round') +
  geom_segment(aes(
    x = deploy_date_time_yyyy_mm_dd_thh_mm_ss, y = station,
    xend = recover_date_time_yyyy_mm_dd_thh_mm_ss, yend = station,
    color = deployment_no),
    #color = "#aeb6bf",
    linewidth = 4.5,
    lineend='round')
geom_label(aes(label = ins_serial_no, x = midpoint, y = station)) +
  scale_color_discrete() + theme_classic()
