library(geosphere)
library(readr)
library(tidyr)
library(dtplyr)
library(dplyr, warn.conflicts = F)

ships_raw <- read_csv("data/ships.csv")

ships_dt <- lazy_dt(ships_raw) %>%
  group_by(SHIPNAME, PORT) %>%
  arrange(DATETIME, .by_group = T) %>%
  mutate(long_diff = LON - lag(LON),
         lat_diff = LAT - lag(LAT),
         prev_lon = lag(LON),
         prev_lat = lag(LAT),
         prev_datetime = lag(DATETIME)) %>%
  as_tibble()

ships_final <- ships_dt %>%
  drop_na(lat_diff, long_diff) %>%
  # filter(lat_diff !=0 & long_diff !=0) %>% # faster but excludes ships that don't move
  mutate(dist = distCosine(cbind(LON,LAT), cbind(prev_lon,prev_lat))) %>%
  group_by(SHIPNAME) %>% # remove port grouping
  arrange(desc(dist), desc(DATETIME)) %>%
  slice_head()

write_csv(ships_final, "data/ships_processed.csv")