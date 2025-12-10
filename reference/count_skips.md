# Find the number of lines to skip in a text file of data

Find the number of lines to skip in a text file of data

## Usage

``` r
count_skips(.connection, .header_pattern)
```

## Arguments

- .connection:

  `<obj>` A connection object, like one gets from
  [`file()`](https://rdrr.io/r/base/connections.html)

- .header_pattern:

  `<chr>` A regular expression for
  [`grepl()`](https://rdrr.io/r/base/grep.html) to search for

## Value

`<int>` the number of lines searched before the pattern is found
