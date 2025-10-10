#' Pivot and split assessment fields with time and context data in the column name
#'
#' @param .panorama_data a "Data" item from running [batch_import_raw_reports()]
#' @param .patterns a vector of at least some named regular expressions, a la [tidyr::separate_wider_regex()]
#'
#' @return a tibble with four columns: School, Student Student Number, Field, and Observation.
#' @export
wrangle_panorama_fields <- function(.panorama_data, .patterns) {
    .whole_pattern <- .patterns |>
        rlang::set_names(nm = "") |>
        purrr::imap_chr(as_captures) |>
        paste0(collapse = "")

    if (.panorama_data |>
        dplyr::select(tidyselect::matches(.whole_pattern)) |>
        ncol() == 0) {
        return(tibble::tibble())
    }

    .panorama_data |>
        dplyr::select(
            tidyselect::any_of(c("School", "Student Student Number")),
            tidyselect::matches(.whole_pattern)
        ) |>
        tidyr::pivot_longer(
            cols = tidyselect::matches(.whole_pattern),
            names_to = "SPLIT_ME",
            values_to = "Observation"
        ) |>
        dplyr::filter(
            !is.na(.data$Observation)
        ) |>
        tidyr::separate_wider_regex(
            cols = "SPLIT_ME",
            patterns = .patterns,
            too_few = "align_start"
        ) |>
        tidyr::pivot_wider(
            names_from = "Field",
            values_from = "Observation",
            values_fn = list
        ) |>
        tidyr::unnest(
            cols = c("Status", "Value")
        )
}
