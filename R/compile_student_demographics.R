#' Join tables of individual student demographic data into a single one
#'
#' @param .source_table the table that describes which file a column comes from
#' @param ... tables of student demographic data as produced by `student_info_table()`
#'
#' @returns <data_frame>
#'   a data frame with many columns, including source_id, row, School, and
#'   demographic information from each element of `...`
#' @export
compile_student_demographics <- function(.source_table, ...) {
    list(...) |>
        purrr::reduce(
            \(.lhs, .rhs) dplyr::left_join(.lhs,
                                           .rhs,
                                           by = c("source_id", "row"))
        ) |>
        dplyr::inner_join(
            dplyr::select(.source_table,
                          source_id = "context_id",
                          School = "full_name"),
            by = "source_id"
        )
}
