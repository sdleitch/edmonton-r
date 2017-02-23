require(rgeos)
require(rgdal)
require(raster)
require(ggplot2)
require(viridis)
require(dplyr)
require(gtable)
require(grid)

# Bring in nhoods by age from 2016 Edmonton municipal census
census_data <- read.csv("2016_Census_-_Population_By_Age_Range__Neighbourhood_.csv")
# neighbourhoods GeoJSON
nhoods <- readOGR("neighbourhoods.geojson")
nhoods_fortify <- fortify(nhoods, region='number')
nhoods_fortify$id <- as.integer(nhoods_fortify$id)

# Join the tables by neighbourhood ID#
map_data <- left_join(
  nhoods_fortify, census_data, by = c("id" = "Neighbourhood.Number")
)

# total # of people in census who gave age
map_data$counted_people <- rowSums(map_data[c(10:27)], na.rm = TRUE)

# Find the appx avg age of the nhood
# This is a very rough guess!
# !!Do not use for anything important!!
loop <- 0
total <- integer(dim(map_data[c(10:27)])[1])

for (col in map_data[c(10:27)]) {
  loop <- loop + 1
  total <- total + (col * ((loop * 5) - 3))
}
map_data$avg_age <- total / map_data$counted_people

# debugging
# print(head(map_data))
# print(dim(map_data))

# mapping

p <- ggplot() +
  geom_polygon(data = map_data, aes(
    fill = avg_age,
    x = long,
    y = lat,
    group = group)) +
  geom_path(data = map_data, aes(
    x = long,
    y = lat,
    group = group),
    color = "white", size = 0.1) +
  labs(
    x = NULL,
    y = NULL,
    title = "Edmonton neighbourhood demographics", 
    subtitle = "Average age in neighbourhoods, 2016 (approx.)"
  ) +
  #coord_equal() +
  scale_fill_viridis(
    option = "magma",
    name = "Average age",
    direction = -1,
    guide = guide_legend(
      keyheight = unit(5, units = "mm"),
      title.position = 'top',
      reverse = T
    )
  )

ggsave("charts/population-map.png")
  







