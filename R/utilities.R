as_table_name <- function(.file_name) {
    .file_name |>
        basename() |>
        stringr::str_extract("^[^.(]+") |>
        stringr::str_replace_all("\\s", "_")
}

assign_table_from_file <- function(.filename, ...) {
    .filename |>
        as_table_name() |>
        assign(readr::read_csv(.filename), ...)
}
