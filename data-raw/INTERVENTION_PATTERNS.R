INTERVENTION_PATTERNS <- c("Intervention",
                           "\\s",
                           Number = "\\d+",
                           "\\s",
                           Field = ".*")


usethis::use_data(INTERVENTION_PATTERNS, overwrite = TRUE)
