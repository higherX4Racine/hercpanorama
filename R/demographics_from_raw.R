#' Pull individual student information from a table of raw school data
#'
#' @param .raw_data an output from running [batch_import_raw_reports()]
#'
#' @return a table with the following columns
#' \describe{
#'   \item{School}{`<chr>` the name of the school}
#'   \item{Student Student Number}{`<int>` a unique id for the student}
#'   \item{Student First Name}{`<chr>` the student's given name}
#'   \item{Student Last Name}{`<chr>` the student's family name}
#'   \item{Gender}{`<chr>` "Male" or "Female", so actually sex not gender}
#'   \item{504 Status}{`<chr>` in WI, a 504 plan is a formal, personalized plan for special education }
#'   \item{ELL Status}{`<chr>` whether or not the student is learning English}
#'   \item{Grade Level}{`<chr>` PK, K4, KG, or 1-12}
#'   \item{Date of Birth}{`<date>`}
#'   \item{Race Ethnicity}{`<chr>` federal OMB race/ethnicity}
#'   \item{Special ED Status}{`<chr>` whether or not the student is enrolled in special education}
#' }
#' @export
demographics_from_raw <- function(.raw_data) {
    .tmp <- .raw_data |>
        dplyr::select(
            tidyselect::all_of(c("School", "Demographics"))
        ) |>
        tidyr::unnest(
            "Demographics"
        ) |>
        dplyr::distinct()
    if ("Date of Birth" %in% names(.tmp)) {
        .tmp <- .tmp |>
            dplyr::mutate(
                `Date of Birth` = lubridate::mdy(.data$`Date of Birth`)
            )
    }
    return(.tmp)
}
