# Parse the filenames of and import the data from multiple Panorama csv files

Parse the filenames of and import the data from multiple Panorama csv
files

## Usage

``` r
batch_import_raw_reports(.filenames)
```

## Arguments

- .filenames:

  \<chr\> a vector of paths to student-level Panorama files

## Value

a table with the fields from
[`filenames_to_tibble()`](https://higherx4racine.github.io/hercpanorama/reference/filenames_to_tibble.md)
and
[`import_raw_report()`](https://higherx4racine.github.io/hercpanorama/reference/import_raw_report.md)
