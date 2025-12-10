# Pivot and split assessment fields with time and context data in the column name

Pivot and split assessment fields with time and context data in the
column name

## Usage

``` r
wrangle_panorama_fields(.panorama_data, .patterns)
```

## Arguments

- .panorama_data:

  a "Data" item from running
  [`batch_import_raw_reports()`](https://higherx4racine.github.io/hercpanorama/reference/batch_import_raw_reports.md)

- .patterns:

  a vector of at least some named regular expressions, a la
  [`tidyr::separate_wider_regex()`](https://tidyr.tidyverse.org/reference/separate_wider_delim.html)

## Value

a tibble with four columns: School, Student Student Number, Field, and
Observation.
