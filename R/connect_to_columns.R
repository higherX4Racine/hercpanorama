#' Join a table of context information to the columns table
#'
#' @param .frame a table of context information
#' @param .columns_frame the table of column information
#'
#' @returns a new data frame joining by `column_id`
#' @export
connect_to_columns <- function(.frame, .columns_frame) {
    .frame |>
        dplyr::inner_join(
            .columns_frame,
            by = "context_id"
        ) |>
        dplyr::mutate(
            column_id = sprintf("%s%08x",
                                .data$source_id,
                                .data$index)
        )
}
