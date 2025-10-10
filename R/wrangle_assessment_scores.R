#' Condense values that describe student scores into a single table
#'
#' @param .panoramel_findings a dataframe produced by [read_panoramel_spreadsheet()]
#'
#' @returns a data frame with student scores on specific assessments
#' @export
#' @seealso [connect_to_columns()]
wrangle_assessment_scores <- function(.panoramel_findings) {
    .statuses <- .panoramel_findings$el_assessment |>
        dplyr::filter(
            .data$unit == "Status"
        ) |>
        hercpanorama::connect_to_columns(
            .panoramel_findings$columns
        ) |>
        dplyr::inner_join(
            .panoramel_findings$String_measures,
            by = "column_id"
        ) |>
        dplyr::select(
            "source_id",
            "row",
            "year",
            "month",
            "assessment",
            status = "value"
        )
    .values <- .panoramel_findings$el_assessment |>
        dplyr::filter(
            .data$unit == "Value"
        ) |>
        hercpanorama::connect_to_columns(
            .panoramel_findings$columns
        ) |>
        dplyr::inner_join(
            .panoramel_findings$Float64_measures,
            by = "column_id"
        ) |>
        dplyr::select(
            "source_id",
            "row",
            "year",
            "month",
            "assessment",
            "value"
        )

    dplyr::inner_join(.values,
                      .statuses,
                      by = c("source_id",
                             "row",
                             "year",
                             "month",
                             "assessment"))
}
