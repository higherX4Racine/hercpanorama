#' Tidy assessment data into long format
#'
#' @param .panorama_data output from [import_raw_report()]
#'
#' @return a tibble with fields that depend upon the suite of assessments
#' @export
wrangle_assessment_fields <- function(.panorama_data) {
    .tmp <- .panorama_data |>
        dplyr::select(
            !tidyselect::starts_with("NWEA MAP Growth")
        ) |>
        wrangle_panorama_fields(
            hercpanorama::ASSESSMENT_PATTERNS
        )

    if (nrow(.tmp) > 0) {
        .tmp <- .tmp |>
            tidyr::separate_wider_delim(
                "Status",
                delim = " - ",
                names = c("Achievement Level", "Achievement Label"),
                too_few = "align_start",
                too_many = "merge"
            ) |>
            dplyr::mutate(
                dplyr::across(c("Year", "Value", "Achievement Level"),
                              as.numeric)
            )
    }

    return(.tmp)
}
