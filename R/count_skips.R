## Copyright (C) 2025 by Higher Expectations for Racine County

#' Find the number of lines to skip in a text file of data
#'
#' @param .connection `<obj>` A connection object, like one gets from [`file()`]
#' @param .header_pattern `<chr>` A regular expression for [`grepl()`] to search for
#'
#' @returns `<int>` the number of lines searched before the pattern is found
#' @export
count_skips <- function(.connection, .header_pattern) {
    .skips <- 0
    .line <- readLines(.connection, 1)
    while (length(.line)) {
        if (grepl(.header_pattern, .line)) {
            break
        }
        .skips <- .skips + 1
        .line <- readLines(.connection, 1)
    }
    return(.skips)
}
