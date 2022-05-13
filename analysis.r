require("httr")
require("jsonlite")
require("readr")
require("dplyr")
require("tidyr")

base <-
    "https://marketplace.visualstudio.com/_apis/public/gallery/extensionquery?api-version=7.1-preview.1"
text <- read_file("body.txt")

r <- POST(base,
    body = text,
    add_headers("Content-Type" = "application/json")
)
response <- content(r)
extensions <- response$results[[1]]$extensions

extns <- data.frame()

for (extension in extensions) {
    extn_data <- data.frame(
        id = paste0(
            extension$publisher$publisherName,
            ".", extension$extensionName
        ),
        publisher = extension$publisher$displayName,
        extension = extension$displayName
    )
    stats <- data.frame()
    for (stat in extension$statistics) {
        stats <- rbind(
            stats,
            stat
        )
    }
    tryCatch(
        expr = {
            extn_data <- cbind(
                extn_data,
                pivot_wider(stats, names_from = "statisticName")
            )
            extns <- rbind(extns, extn_data)
        },
        simpleError = function(e) {
            print(paste0(
                "!!! Error ", extension$publisher$publisherName,
                ".", extension$extensionName
            ))
        },
        finally = {
            extn_data <- NULL
            stats <- NULL
        }
    )
}

write.csv(extns, "data.csv", row.names = FALSE)

View(extns)