# Join tables of individual student demographic data into a single one

Join tables of individual student demographic data into a single one

## Usage

``` r
compile_student_demographics(.source_table, ...)
```

## Arguments

- .source_table:

  the table that describes which file a column comes from

- ...:

  tables of student demographic data as produced by
  [`student_info_table()`](https://higherx4racine.github.io/hercpanorama/reference/student_info_table.md)

## Value

\<data_frame\> a data frame with many columns, including source_id, row,
School, and demographic information from each element of `...`
