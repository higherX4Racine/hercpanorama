NWEA_MAP_GROWTH_PATTERNS <- c(
    Subject = "NWEA MAP.*",
    "\\s+",
    Year = "\\d{4}",
    "\\s+",
    Season = ".*",
    "\\s+",
    Field = "[^\\.]+",
    ".*"
)

usethis::use_data(NWEA_MAP_GROWTH_PATTERNS, overwrite = TRUE)
