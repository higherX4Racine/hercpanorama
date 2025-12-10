# Create a one-student, one-field table for a single kind of demographic info

Create a one-student, one-field table for a single kind of demographic
info

## Usage

``` r
student_info_table(
  .student_table,
  .columns_table,
  .field,
  .measures,
  .value_name
)
```

## Arguments

- .student_table:

  a context table with student demographic fields

- .columns_table:

  the table of individual column information

- .field:

  the name of the field to search for in `.student_table`

- .measures:

  the table of measures where the field's values are stored

- .value_name:

  the name of the field in the output table

## Value

a data frame with three columns: source_id, row, and `.value_name`
