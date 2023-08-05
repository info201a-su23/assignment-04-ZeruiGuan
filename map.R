library(ggmap)
library(leaflet)
library(dplyr)

register_google("AIzaSyDdCbwqRZARe3X-pGJ9M-jt32HPLomT04s")

crime_rate_data <- read.csv("us-prison-jail-rates.csv")

unique_locations <- unique(crime_rate_data$state)

latitudes <- vector("numeric", length(unique_locations))
longitudes <- vector("numeric", length(unique_locations))

for (i in seq_along(unique_locations)) {
  location <- unique_locations[i]
  geocode_result <- geocode(location)
  latitudes[i] <- geocode_result$lat
  longitudes[i] <- geocode_result$lon
}

location_data <- data.frame(state = unique_locations, lat = latitudes,
                            lon = longitudes)

merged_data <- merge(crime_rate_data, location_data, by = "state")
merged_data <- na.omit(merged_data)

data <- merged_data %>% group_by(state, lat, lon) %>%
  summarise(avg_crime_rate = mean(total_jail_pop_rate))

map <- leaflet(data) %>%
  addProviderTiles("Stamen.TonerLite") %>%
  addCircleMarkers(
    lat = data$lat,
    lng = data$lon, 
    radius = data$avg_crime_rate / 100,
    popup = paste0("Average jail rate per 100,000 population: ",
                   data$avg_crime_rate),
    fillOpacity = 0.6
  )

html_code = "<p>Average jail rate per 100,000 population by location</p>"

map <- addControl(map,
                  html = html_code, position = "topright")