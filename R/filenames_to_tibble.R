#' Parse Panorama file names into their component fields.
#'
#' @param .filenames &lt;chr&gt; full paths or basenames to Panorama files.
#' @param .tz &lt;db&gt; optional, the timezone the files were downloaded in.
#'
#' @return a tibble with six columns: File, School, Population, Report, Period, and Datetime
#' @export
#'
#' @examples
#' filenames_to_tibble("StarbuckInternationalSchool_students_ELA_YTD_20241203140402.csv")
filenames_to_tibble <- function(.filenames, .tz = Sys.timezone()) {
    .matches <- .filenames |>
        stringr::str_match(
            pattern = hercpanorama::FILE_PATTERNS |>
                purrr::imap_chr(as_captures) |>
                paste0(collapse = "")
        )
    colnames(.matches)[1] <- "File"
    .matches |>
        tibble::as_tibble() |>
        dplyr::mutate(
            Datetime = lubridate::as_datetime(.data$Datetime,
                                              tz = .tz)
        )
}
