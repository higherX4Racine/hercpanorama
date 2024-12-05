test_that("one named argument produces one named capture expression", {
  expect_equal(
      as_captures(c(Foo = "bar")),
      "(?<Foo>bar)"
  )
})

test_that("one unnamed argument produces one non-capturing expression", {
    expect_equal(
        as_captures(c(".*")),
        ".*"
    )
})

test_that("multiple arguments combine named captures and non-captures", {
    expect_equal(
        as_captures(c("a+", "b+", "c+"), c("foo", "", "baz")),
        c("(?<foo>a+)", "b+", "(?<baz>c+)")
    )
})

test_that("a named vector of expressions combines named captures and nons", {
    expect_equal(
        as_captures(c(foo = "\\w+", "\\s+", baz = "\\d+")),
        c("(?<foo>\\w+)", "\\s+", "(?<baz>\\d+)")
    )
})
