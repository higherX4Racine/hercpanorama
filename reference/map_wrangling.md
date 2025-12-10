# Title

Title

## Usage

``` r
map_wrangling(.x, .list_col, .wrangler, ...)
```

## Arguments

- .x:

  a nested data frame that needs mapped wrangling

- .list_col:

  the column of nested data frames

- .wrangler:

  the function for wrangling each nested element

- ...:

  additional columns to include in the output

## Value

a data frame with columns from `.wrangler(.list_col)` and `...`
