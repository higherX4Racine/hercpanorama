#' Title
#'
#' @param .x a nested data frame that needs mapped wrangling
#' @param .list_col the column of nested data frames
#' @param .wrangler the function for wrangling each nested element
#' @param ... additional columns to include in the output
#'
#' @returns a data frame with columns from `.wrangler(.list_col)` and `...`
#' @export
map_wrangling <- function(.x, .list_col, .wrangler, ...) {
    .x |>
        dplyr::mutate(
            "SOON_TO_BE_UNNESTED" = purrr::map(.data[[.list_col]],
                                               .wrangler)
        ) |>
        dplyr::select(
            tidyselect::all_of(c(..., "SOON_TO_BE_UNNESTED"))
        ) |>
        tidyr::unnest(
            cols = "SOON_TO_BE_UNNESTED"
        )
}
