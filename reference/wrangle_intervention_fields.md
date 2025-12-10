# Title

Title

## Usage

``` r
wrangle_intervention_fields(.panorama_data)
```

## Arguments

- .panorama_data:

  the result of running
  [`import_raw_report()`](https://higherx4racine.github.io/hercpanorama/reference/import_raw_report.md)

## Value

a table with the following columns

- Student Student Number:

  `<int>` a unique id for the student

- Number:

  `<int>` which intervention

- Tier:

  `<int>` the intensity of the intervention

- Type and Strategy:

  `<chr>`the nature of the intervention

- Status:

  `<chr>` what stage the intervention is in

- Start Date:

  `<date>`
