# Extract text from a csv-formatted student-level file output from Panorama

The table will have at least 10 columns of demographic and identifying
data:

## Usage

``` r
import_raw_report(.filename)
```

## Arguments

- .filename:

  `<chr>` the full path to the file

## Value

an object of class `tbl_df`, `tbl`, `data.frame` with at least 10
columns

- `Student Student Number`:

  `<int>` the student's unique ID

- `Student First Name`:

  `<chr>` the student's given name

- `Student Last Name`:

  `<chr>` the student's family name

- `Gender`:

  `<chr>` female or male

- `504 Status`:

  `<chr>` whether or not the student has a personal learning plan

- `ELL Status`:

  `<chr>` whether or not the student is learning English as an
  additional language

- `Grade Level`:

  `<chr>` what grade the student is in.

- `Date of Birth`:

  `<date>` students' birthdays don't seem to appear in later data sets

- `Race Ethnicity`:

  `<chr>` one of the OMB '97 race/ethnicites

- `Special ED Status`:

  `<chr>` whethe or not the student participates in special education
  services
