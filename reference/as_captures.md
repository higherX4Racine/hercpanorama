# Make a named vector of capture expressions from one of regular expressions.

Use blank names for any expressions that you want to match, but not to
capture.

## Usage

``` r
as_captures(.regexes, .labels = NULL)
```

## Arguments

- .regexes:

  \<chr\> a vector of capturing expressions

- .labels:

  \<chr\> optional, names for each capturing expression.

## Value

a vector of expressions, some of which may be named capture groups.

## Examples

``` r
foo <- c(bar = "\\d+", "\\D+", baz = "\\d+")
as_captures(foo)
#> [1] "(?<bar>\\d+)" "\\D+"         "(?<baz>\\d+)"
```
