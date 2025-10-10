#' Create a one-student, one-field table for a single kind of demographic info
#'
#' @param .student_table a context table with student demographic fields
#' @param .columns_table the table of individual column information
#' @param .field the name of the field to search for in `.student_table`
#' @param .measures the table of measures where the field's values are stored
#' @param .value_name the name of the field in the output table
#'
#' @returns a data frame with three columns: source_id, row, and `.value_name`
#' @export
student_info_table <- function(.student_table,
                               .columns_table,
                               .field,
                               .measures,
                               .value_name) {
    .student_table |>
        dplyr::filter(
            .data$field == .field
        ) |>
        connect_to_columns(.columns_table) |>
        dplyr::inner_join(
            .measures,
            by = "column_id",
            relationship = "one-to-many"
        ) |>
        dplyr::select(
            "source_id",
            "row",
            "{.value_name}" := "value"
        )
}
