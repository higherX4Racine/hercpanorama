#' Parse the filenames of and import the data from multiple Panorama csv files
#'
#' @param .filenames &lt;chr&gt; a vector of paths to student-level Panorama files
#'
#' @return a table with the fields from [filenames_to_tibble()] and [import_raw_report()]
#' @export
batch_import_raw_reports <- function(.filenames) {
    .filenames |>
        filenames_to_tibble() |>
        dplyr::mutate(
            Data = purrr::map(
                .data$File,
                import_raw_report
            ),
            Demographics = purrr::map(
                .data$Data,
                \(.t) dplyr::select(
                    .t,
                    tidyselect::all_of(names(hercpanorama::DEMOGRAPHIC_FIELDS))
                )
            ),
            Data = purrr::map(
                .data$Data,
                \(.t) dplyr::select(
                    .t,
                    !tidyselect::any_of(setdiff(names(hercpanorama::DEMOGRAPHIC_FIELDS),
                                                "Student Student Number"))
                )
            )
        )
}
