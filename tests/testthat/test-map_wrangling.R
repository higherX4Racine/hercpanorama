fixture <- tibble::tibble(
    A = LETTERS[1:3],
    B = 1:3,
    C = purrr::map(1:3,
                   \(.n) {
                       tibble::tibble(x = letters[1:.n],
                                      y = .n + 1:.n - 1)
                   }
    )
)

test_that("unpacking and selecting works", {

    expect_equal(nrow(fixture), 3L)

    should_be <- tibble::tibble(
        A = c("A", "B", "B", "C", "C", "C"),
        B = c(1L, 2L, 2L, 3L, 3L, 3L),
        x = c("a", "a" , "b", "a", "b", "c"),
        y = c(1, 2, 3, 3, 4, 5)
    )

    expect_equal(
        map_wrangling(fixture, "C", I),
        dplyr::select(should_be, "x", "y")
    )

    expect_equal(
        map_wrangling(fixture, "C", I, "A"),
        dplyr::select(should_be, "A", "x", "y")
    )

    expect_equal(
        map_wrangling(fixture, "C", I, "B", "A"),
        dplyr::select(should_be, "B", "A", "x", "y")
    )


})
