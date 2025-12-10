## Copyright (C) 2025 by Higher Expectations for Racine County

#' Extract text from a csv-formatted student-level file output from Panorama
#'
#' The table will have at least 10 columns of demographic and identifying data:
#'
#' @param .filename `<chr>` the full path to the file
#'
#' @return an object of class `tbl_df`, `tbl`, `data.frame`
#' with at least 10 columns
#' \describe{
#'   \item{`Student Student Number`}{ `<int>` the student's unique ID}
#'   \item{`Student First Name`}{ `<chr>` the student's given name}
#'   \item{`Student Last Name`}{ `<chr>` the student's family name}
#'   \item{`Gender`}{ `<chr>` female or male}
#'   \item{`504 Status`}{ `<chr>` whether or not the student has a personal learning plan}
#'   \item{`ELL Status`}{ `<chr>` whether or not the student is learning English as an additional language}
#'   \item{`Grade Level`}{ `<chr>` what grade the student is in.}
#'   \item{`Date of Birth`}{ `<date>` students' birthdays don't seem to appear in later data sets}
#'   \item{`Race Ethnicity`}{ `<chr>` one of the OMB '97 race/ethnicites}
#'   \item{`Special ED Status`}{ `<chr>` whethe or not the student participates in special education services}
#' }
#' @export
import_raw_report <- function(.filename) {
    .skips <- .filename |>
        file("rt") |>
        withr::local_connection() |>
        count_skips(paste0(names(hercpanorama::DEMOGRAPHIC_FIELDS),
                           collapse = "|"))
    readr::read_csv(.filename,
                    col_types = c(hercpanorama::DEMOGRAPHIC_FIELDS,
                                  list(.default = "c")),
                    skip = .skips)
}
