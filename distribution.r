library(tidyverse)
library(ggplot2)


data <- read.csv("data.csv", header = TRUE)
v <- data |> select(id, ratingcount, install)

breaks <- c(1, 10, 50, 100, 300, 500, 1000, 3000)
tags <- c("1-10", "11-50", "51-100", "101-300", "301-500", "501-1000", "1000+")
group_tags <- cut(v$ratingcount,
    breaks = breaks, labels = tags, include.lowest = TRUE,
    right = FALSE,
)

tbl <- as_tibble(group_tags)
ggplot(data = tbl, mapping = aes(x = value)) +
    geom_bar(fill = "bisque", color = "white") +
    labs(x = "Rating distribution", y = "Number of reviews") +
    theme_bw()

ggsave("rating.png", plot = last_plot(), scale = 0.5)