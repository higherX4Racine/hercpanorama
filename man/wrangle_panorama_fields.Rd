% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/wrangle_panorama_fields.R
\name{wrangle_panorama_fields}
\alias{wrangle_panorama_fields}
\title{Pivot and split assessment fields with time and context data in the column name}
\usage{
wrangle_panorama_fields(.panorama_data, .patterns)
}
\arguments{
\item{.panorama_data}{a "Data" item from running \code{\link[=batch_import_raw_reports]{batch_import_raw_reports()}}}

\item{.patterns}{a vector of at least some named regular expressions, a la \code{\link[tidyr:separate_wider_delim]{tidyr::separate_wider_regex()}}}
}
\value{
a tibble with four columns: School, Student Student Number, Field, and Observation.
}
\description{
Pivot and split assessment fields with time and context data in the column name
}
