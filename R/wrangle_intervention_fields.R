#' Title
#'
#' @param .panorama_data the result of running [import_raw_report()]
#'
#' @return a table with the following columns
#' \describe{
#'   \item{Student Student Number}{`<int>` a unique id for the student}
#'   \item{Number}{`<int>` which intervention }
#'   \item{Tier}{`<int>` the intensity of the intervention}
#'   \item{Type and Strategy}{`<chr>`the nature of the intervention}
#'   \item{Status}{`<chr>` what stage the intervention is in}
#'   \item{Start Date}{`<date>`}
#' }
#' @export
wrangle_intervention_fields <- function(.panorama_data) {
    .tmp <- .panorama_data |>
        wrangle_panorama_fields(
            hercpanorama::INTERVENTION_PATTERNS
        )

    if (nrow(.tmp) > 0) {
        .tmp <- dplyr::mutate(
            .tmp,
            Number = as.integer(.data$Number),
            Tier = .data$Tier |> stringr::str_extract("\\d+$") |> as.integer(),
            `Start Date` = lubridate::mdy(.data$`Start Date`)
        )
    }

    return(.tmp)
}
