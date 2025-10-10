test_that("empty strings are not treated as the end of the file", {
    look_for <- function(.pattern) {
        "data" |>
            test_path(
                "example_data_file.txt"
            ) |>
            file(
                "rt"
            ) |>
            withr::local_connection() |>
            count_skips(
                .pattern
            )
    }

  expect_equal(look_for("a"), 0)
  expect_equal(look_for("b"), 1)
  expect_equal(look_for("c"), 2)
  expect_equal(look_for("d"), 4)
  expect_equal(look_for("e"), 5)
})
