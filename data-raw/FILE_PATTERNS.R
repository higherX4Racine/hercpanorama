FILE_PATTERNS <- c(
    ".*(?<=/|^)",
    School = "[^_]+",
    "_",
    Population = "[^_]+",
    "_",
    Report = "[^_]+",
    "_",
    Period = "[^_]+",
    "_",
    Datetime = "\\d+",
    "\\.csv$"
)


usethis::use_data(FILE_PATTERNS, overwrite = TRUE)
