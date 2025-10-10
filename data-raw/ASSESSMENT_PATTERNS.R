ASSESSMENT_PATTERNS <- c(
    Assessment = ".*",
    "\\s+",
    Month = "\\w+",
    "\\s+",
    Year = "\\d{4}",
    "\\s+",
    Field = ".*"
)

usethis::use_data(ASSESSMENT_PATTERNS, overwrite = TRUE)
