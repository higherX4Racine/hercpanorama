DEMOGRAPHIC_FIELDS <- list(
    `Student Student Number` = "i",
    `Student First Name` = "c",
    `Student Last Name` = "c",
    Gender = "c",
    `504 Status` = "c",
    `ELL Status` = "c",
    `Grade Level` = "c",
    `Date of Birth` = readr::col_date(format = ""),
    `Race Ethnicity` = "c",
    `Special ED Status` = "c"
)

usethis::use_data(DEMOGRAPHIC_FIELDS, overwrite = TRUE)
