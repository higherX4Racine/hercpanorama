#' Make a named vector of capture expressions from one of regular expressions.
#'
#' Use blank names for any expressions that you want to match, but not to
#' capture.
#'
#' @param .regexes <chr> a vector of capturing expressions
#' @param .labels <chr>, optional, names for each capturing expression.
#'
#' @return a vector of expressions, some of which may be named capture groups.
#' @export
#'
#' @examples
#' foo <- c(bar = "\\d+", "\\D+", baz = "\\d+")
#' as_captures(foo)
as_captures <- function(.regexes, .labels = NULL) {
    if (is.null(.labels)) {
        .labels <- names(.regexes)
    }
    names(.regexes) <- NULL
    if (is.character(.labels)) {
        return(
            dplyr::if_else(nchar(.labels) > 0,
                           paste0("(?<", .labels, ">", .regexes, ")"),
                           .regexes)
        )
    }
    return(.regexes)
}
