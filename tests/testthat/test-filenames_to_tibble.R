test_that("different weird or absent path prefixes are all ignored", {

    example_paths <- c(
        "C:/Documents/Data/Downloads/Racine Unified/KnappElementary_students_ELA_YTD_20241203140002.csv",
        "/Documents/Data/Downloads/Racine Unified/SCJohnsonElementary_students_ELA_FullYear_20241203140237.csv",
        "~/Data/Downloads/Racine Unified/SCJohnsonElementary_students_ELA_YTD_20241203140245.csv",
        "StarbuckInternationalSchool_students_ELA_YTD_20241203140402.csv"
    )
    expect_equal(
        filenames_to_tibble(example_paths),
        tibble::tibble(
            File = example_paths,
            School = c("KnappElementary",
                       "SCJohnsonElementary",
                       "SCJohnsonElementary",
                       "StarbuckInternationalSchool"),
            Population = "students",
            Report = "ELA",
            Period = c("YTD", "FullYear", "YTD", "YTD"),
            Datetime = lubridate::ymd_hms(c("20241203140002",
                                            "20241203140237",
                                            "20241203140245",
                                            "20241203140402"),
                                          tz = Sys.timezone())
        )
    )
})

test_that("different timezones are handled correctly", {
    times <- tibble::tribble(
        ~ Timestamp,       ~ Timezone,
        "20241208193955", "America/Chicago",
        "20241208213955", "America/Vancouver",
        "20241208233955", "Pacific/Honolulu",
        "20241208033955", "Asia/Vladivostok",
        "20241208053955", "Australia/Perth",
        "20241208075455", "Asia/Kathmandu",
        "20241208113955", "Europe/Kyiv",
        "20241208103955", "Africa/Dar_es_Salaam",
        "20241208123955", "Europe/Copenhagen",
        "20241208133955", "Africa/Dakar",
        "20241208163955", "America/Bahia",
        "20241208173955", "Atlantic/Bermuda"
    ) |>
        dplyr::mutate(
            `Should Be` = lubridate::ymd_hms(.data$Timestamp, tz = "US/Central")
        )

    tibbled_files <- purrr::map(
        times$Timezone,
        \(.tz) {
            withr::local_timezone(.tz)
            filenames_to_tibble("Elementary_students_ELA_YTD_20241208193955.csv")
        }
    ) |>
        purrr::list_rbind()

    expect_equal(
        lubridate::with_tz(times$`Should Be`, tzone = "America/Chicago"),
        tibbled_files$Datetime
    )
})
