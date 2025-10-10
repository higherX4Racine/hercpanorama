#' Read the pages of a spreadsheet into a list of data frames
#'
#' @param .filename the full path to the spreadsheet
#'
#' @returns a list of data frames, one per sheet in the source file
#' @export
read_panoramel_spreadsheet <- function(.filename) {
    .filename |>
        readxl::excel_sheets() |>
        rlang::set_names() |>
        purrr::map(
            \(.sheet) readxl::read_excel(.filename,
                                         .sheet)
        )
}
