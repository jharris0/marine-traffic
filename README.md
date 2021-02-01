# marine-traffic
Hi! This is my sample shiny.semantic app for visualizing ship movements.

**Notes:**

* Raw data processing and distance calculations are done outside of Shiny using the `process_ships_data.R` script.
* As you no doubt know, some of the values in the raw data appear to be anomalous. (Examples: [SAT-AIS], SAMUR-3.) However, due to time constraints I've decided to leave the data as is rather than try to remove the anomalies.