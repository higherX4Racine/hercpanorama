
#' Extract text from a csv-formatted student-level file output from Panorama
#'
#' The table will have at least 10 columns of demographic and identifying data:
#' * `Student Student Number` &lt;int&gt;
#' * `Student First Name` &lt;chr&gt;
#' * `Student Last Name` &lt;chr&gt;
#' * `Gender` &lt;chr&gt;
#' * `504 Status` &lt;chr&gt;
#' * `ELL Status` &lt;chr&gt;
#' * `Grade Level` &lt;chr&gt;
#' * `Date of Birth` &lt;date&gt;
#' * `Race Ethnicity` &lt;chr&gt;
#' * `Special ED Status` &lt;chr&gt;
#'
#' @param .filename &lt;chr&gt; the full path to the file
#'
#' @return a tibble of student-level data.
#' @export
import_raw_report <- function(.filename) {
    readr::read_csv(.filename,
                    col_types = c(hercpanorama::DEMOGRAPHIC_FIELDS,
                                  list(.default = "c")),
                    skip = 1)
}
