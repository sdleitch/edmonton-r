require(ggplot2)
require(scales)

# Read in Edmonton 2013 municipal election results
housing_starts <- read.csv("Edmonton_-_Historic__Housing_Starts.csv")

g <- ggplot(housing_starts)
g + geom_histogram(aes(x=YEAR, y=NUMBER.OF.UNITS, fill=HOUSING.TYPE), stat="identity")

ggsave("charts/edmonton-housing.png", device="png")