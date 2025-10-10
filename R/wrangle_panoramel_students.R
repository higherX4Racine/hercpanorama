#' Condense values that describe student identity into a single table
#'
#' @param .panoramel_findings a dataframe produced by [read_panoramel_spreadsheet()]
#'
#' @returns a data frame with student demographic information
#' @export
#' @seealso [student_info_table()]
#' @seealso [compile_student_demographics()]
wrangle_panoramel_students <- function(.panoramel_findings){
    student_ids <- hercpanorama::student_info_table(.panoramel_findings$student,
                                                    .panoramel_findings$columns,
                                                    "Student Number",
                                                    .panoramel_findings$UInt64_measures,
                                                    "Student_ID")

    student_grade_levels <- .panoramel_findings$student |>
        hercpanorama::student_info_table(
            .panoramel_findings$columns,
            "Grade Level",
            .panoramel_findings$String_measures,
            "Grade_Level"
        ) |>
        dplyr::mutate(
            Grade_Level = .data$Grade_Level |>
                dplyr::case_match(
                    c("E3", "E4", "PK", "K3", "K4") ~ "PK",
                    c("6", "7", "8") ~ "Middle",
                    .default = .data$Grade_Level
                ) |>
                forcats::fct(
                    levels = c(
                        "PK",
                        "KG",
                        1:8,
                        "Middle"
                    )
                )
        )

    student_race <- .panoramel_findings$student |>
        hercpanorama::student_info_table(
            .panoramel_findings$columns,
            "Race Ethnicity",
            .panoramel_findings$String_measures,
            "Race_Ethnicity"
        ) |>
        dplyr::mutate(
            Race_Ethnicity = .data$Race_Ethnicity |>
                dplyr::coalesce("other") |>
                forcats::fct_collapse(
                    Black = "african american",
                    `Latin@` = "hispanic/latino",
                    White = "white",
                    other_level =  "All Other Races"
                )
        )

    hercpanorama::compile_student_demographics(
        .panoramel_findings$source,
        student_ids,
        student_race,
        student_grade_levels
    )

}
