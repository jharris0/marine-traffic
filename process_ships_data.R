library(readr)
library(tidyr)
library(janitor)
library(dtplyr)
library(dplyr, warn.conflicts = F)
library(geosphere)

ships_raw <- read_csv("data/ships.csv") %>% clean_names()

ships_dt <- lazy_dt(ships_raw) %>%
  group_by(shipname, port) %>%
  arrange(datetime, .by_group = T) %>%
  mutate(long_diff = lon - lag(lon),
         lat_diff = lat - lag(lat),
         prev_lon = lag(lon),
         prev_lat = lag(lat),
         prev_datetime = lag(datetime)) %>%
  as_tibble()

ships_final <- ships_dt %>%
  drop_na(lat_diff, long_diff) %>%
  # filter(lat_diff !=0 & long_diff !=0) %>% # faster but excludes ships that don't move
  mutate(dist = distCosine(cbind(lon,lat), cbind(prev_lon,prev_lat))) %>%
  group_by(shipname) %>% # remove port grouping
  arrange(desc(dist), desc(datetime)) %>%
  slice_head()

write_csv(ships_final, "data/ships_processed.csv")