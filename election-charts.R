require(ggplot2)
require(scales)

# Read in Edmonton 2013 municipal election results
results <- read.csv("2013_Edmonton_Election_-_Official_Results.csv")

wards <- unique(results$WARD_NAME)

for(ward in wards) {
  # subset results from ward, to be charted
  ward_results <- subset(results, subset = results$WARD_NAME == ward)
  title <- paste(as.vector(ward_results$CONTEST), "-", as.vector(ward))
  g <- ggplot(ward_results, aes(
      CANDIDATE_NAME,
      VOTES_RECEIVED,
      fill=CANDIDATE_NAME
    )) +
    geom_bar(stat="identity") +
    scale_y_continuous(labels = comma) +
    scale_fill_discrete(name="Candidates") +
    ggtitle(title) +
    xlab("Name") +
    ylab("Votes received") +
    theme(
      axis.title.x=element_blank(),
      axis.text.x=element_blank(),
      axis.ticks.x=element_blank()
    )
  
  filename <- paste("charts/", title, ".png", sep = "")
  filename <- gsub(" ", filename, replacement = "")
  ggsave(filename = filename, plot = g, device = "png")
}
