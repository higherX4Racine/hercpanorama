# Pull individual student information from a table of raw school data

Pull individual student information from a table of raw school data

## Usage

``` r
demographics_from_raw(.raw_data)
```

## Arguments

- .raw_data:

  an output from running
  [`batch_import_raw_reports()`](https://higherx4racine.github.io/hercpanorama/reference/batch_import_raw_reports.md)

## Value

a table with the following columns

- School:

  `<chr>` the name of the school

- Student Student Number:

  `<int>` a unique id for the student

- Student First Name:

  `<chr>` the student's given name

- Student Last Name:

  `<chr>` the student's family name

- Gender:

  `<chr>` "Male" or "Female", so actually sex not gender

- 504 Status:

  `<chr>` in WI, a 504 plan is a formal, personalized plan for special
  education

- ELL Status:

  `<chr>` whether or not the student is learning English

- Grade Level:

  `<chr>` PK, K4, KG, or 1-12

- Date of Birth:

  `<date>`

- Race Ethnicity:

  `<chr>` federal OMB race/ethnicity

- Special ED Status:

  `<chr>` whether or not the student is enrolled in special education
