# Parse Panorama file names into their component fields.

Parse Panorama file names into their component fields.

## Usage

``` r
filenames_to_tibble(.filenames, .tz = Sys.timezone())
```

## Arguments

- .filenames:

  \<chr\> full paths or basenames to Panorama files.

- .tz:

  \<db\> optional, the timezone the files were downloaded in.

## Value

a tibble with six columns: File, School, Population, Report, Period, and
Datetime

## Examples

``` r
filenames_to_tibble("StarbuckInternationalSchool_students_ELA_YTD_20241203140402.csv")
#> # A tibble: 1 × 6
#>   File                       School Population Report Period Datetime           
#>   <chr>                      <chr>  <chr>      <chr>  <chr>  <dttm>             
#> 1 StarbuckInternationalScho… Starb… students   ELA    YTD    2024-12-03 14:04:02
```
