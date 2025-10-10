
PANORAMEL_FILE <- hiRx::input_path("Iterations",
                                  "Panoramel",
                                  "findings.xlsx")

findings <- hercpanorama::read_panoramel_spreadsheet(PANORAMEL_FILE)


student_ids <- hercpanorama::student_info_table(findings$student,
                                                findings$columns,
                                                "Student Number",
                                                findings$UInt64_measures,
                                                "Student_ID")

student_grade_levels <- findings$student |>
    hercpanorama::student_info_table(
        findings$columns,
        "Grade Level",
        findings$String_measures,
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

student_race <- findings$student |>
    hercpanorama::student_info_table(
        findings$columns,
        "Race Ethnicity",
        findings$String_measures,
        "Race_Ethnicity"
    ) |>
    dplyr::mutate(
        Race_Ethnicity = .data$Race_Ethnicity |>
            dplyr::case_match(
                "african american" ~ "Black",
                "hispanic/latino" ~ "Latin@",
                "white" ~ "White",
                .default = "All Other Races"
            )
    )

student_info <- hercpanorama::compile_student_demographics(
    findings$source,
    student_ids,
    student_race,
    student_grade_levels
)

scores <- findings$el_assessment |>
    dplyr::mutate(
        month = dplyr::if_else(.data$month > 12,
                               7,
                               .data$month)
    ) |>
    hercpanorama::connect_to_columns(findings$columns) |>
    dplyr::inner_join(
        findings$Float64_measures,
        by = "column_id"
    ) |>
    dplyr::select(
        "source_id",
        "row",
        "year",
        "month",
        "assessment",
        "value"
    )

student_scores <- student_info |>
    dplyr::inner_join(
        scores,
        by = c("source_id", "row"),
        relationship = "one-to-many"
    ) |>
    dplyr::mutate(
        Race_Ethnicity = .data$Race_Ethnicity |>
            dplyr::coalesce("All Other Races") |>
            forcats::fct(levels = hiRx::RACE_LABELS_RACINE[1:4]),
        Date = lubridate::make_date(.data$year,
                                    .data$month,
                                    15),
        Calendar_Days = as.integer(
            .data$Date - lubridate::ymd("2024-09-02")
        )
    ) |>
    dplyr::select(
        "School",
        "Grade_Level",
        "Race_Ethnicity",
        "Student_ID",
        Assessment = "assessment",
        "Date",
        "Calendar_Days",
        Score = "value"
    )


orf_scores <- student_scores |>
    dplyr::filter(
        dplyr::between(.data$Date,
                       lubridate::ymd("2024-09-02"),
                       lubridate::ymd("2025-06-13")),
        .data$Assessment == "Amira ORF - English"
    )

PHI <- (1 + sqrt(5)) / 2

plot_scores <- function(.scores, ...) {
        ggplot2::ggplot(
            mapping = ggplot2::aes(
                x = .data$Date,
                y = .data$Score,
                color = .data$Race_Ethnicity,
                ...
            )
        ) +
        ggplot2::geom_point(
            mapping = ggplot2::aes(size = .data$Count),
            data = dplyr::summarize(
                .scores,
                Score = mean(.data$Score, na.rm = TRUE),
                Count = dplyr::n_distinct(.data$Student_ID),
                .by = tidyselect::any_of(c("School",
                                           "Grade_Level",
                                           "Race_Ethnicity",
                                           "Date"))
            ),
            alpha = 0.1
        ) +
        ggplot2::geom_smooth(
            data = .scores,
            method = "loess",
            formula = y ~ x,
            se = FALSE,
            na.rm = TRUE,
            alpha = 0.5
        ) +
        ggplot2::scale_color_manual(
            values = hiRx::higher_ex_pal("race")(5)
        )
}

assessment_plots <- student_scores |>
    dplyr::pull("Assessment") |>
    unique() |>
    sort() |>
    rlang::set_names() |>
    purrr::map(
        \(.assessment) student_scores |>
            dplyr::filter(
                .data$Assessment == .assessment,
                .data$Date > "2024-09-02"
            ) |>
            plot_scores() +
            ggplot2::facet_grid(
                cols = ggplot2::vars(.data$Grade_Level)
            ) +
            ggplot2::labs(
                y = .assessment
            ) +
            ggplot2::theme_minimal()
    )

school_plots <- findings$source$full_name |>
    rlang::set_names() |>
    purrr::map(
        \(.school) names(assessment_plots) |>
            rlang::set_names() |>
            purrr::map(
                \(.assessment) student_scores |>
                    dplyr::filter(
                        .data$School == .school,
                        .data$Assessment == .assessment
                    ) |>
                    plot_scores() +
                    ggplot2::facet_grid(
                        rows = ggplot2::vars(.data$Assessment),
                        cols = ggplot2::vars(.data$Grade_Level)
                    ) +
                    ggplot2::theme_minimal()
            )
    )

orf_formulae <- list(
    null = Score ~ Calendar_Days,
    mains = Score ~ Race_Ethnicity + Grade_Level + Calendar_Days,
    parsimonious = Score ~ Race_Ethnicity + Grade_Level + Calendar_Days + Race_Ethnicity:Calendar_Days,
    gradewise = Score ~ Race_Ethnicity * Grade_Level + Calendar_Days,
    ambitious = Score ~ Race_Ethnicity + Grade_Level + Calendar_Days + Grade_Level:Calendar_Days + Race_Ethnicity:Grade_Level:Calendar_Days,
    full = Score ~ Race_Ethnicity * Grade_Level * Calendar_Days
)

district_orf <- orf_formulae |>
    purrr::map(
        \(.formula) nlme::lme(
            .formula,
            data = orf_scores,
            random = ~ Calendar_Days | School / Student_ID,
            method = "ML"
        )
    )

model_test <- with(district_orf,
                   anova(null,
                         mains,
                         parsimonious,
                         gradewise,
                         ambitious,
                         full,
                         test = TRUE)
)

orf_models <- findings$source$full_name |>
    rlang::set_names() |>
    purrr::map(
        purrr::safely(\(.school) orf_scores |>
                          dplyr::filter(
                              .data$School == .school,
                          ) |>
                          nlme::lme(
                              fixed = orf_formulae$ambitious,
                              data = _,
                              random = ~ Calendar_Days | Student_ID
                          )
        )
    ) |>
    purrr::keep(
        \(.l) !is.null(.l$result)
    ) |>
    purrr::map(
        \(.l) .l$result
    )

BASIS <- orf_scores |>
    dplyr::count(
        .data$Grade_Level,
        .data$Race_Ethnicity,
        .data$Student_ID
    ) |>
    dplyr::count(
        .data$Grade_Level,
        .data$Race_Ethnicity,
        name = "Students"
    ) |>
    tidyr::expand_grid(
        Date = lubridate::ymd(c("2024-09-03", "2025-06-12"))
    ) |>
    dplyr::mutate(
        Calendar_Days = as.integer(.data$Date - lubridate::ymd("2024-09-02")),
        Race_Ethnicity = factor(.data$Race_Ethnicity,
                             levels = hiRx::RACE_LABELS_RACINE[1:4])
    )

orf_predictions <- BASIS

purrr::iwalk(orf_models,
             \(.model, .label)
             orf_predictions[[.label]] <<- predict(.model, BASIS, level = 0)
)

orf_predictions <- orf_predictions |>
    tidyr::pivot_longer(
        cols = !tidyselect::any_of(names(BASIS)),
        names_to = "School",
        values_to = "Score"
    )

prediction_plots <- ggplot2::ggplot(
    mapping = ggplot2::aes(
        x = .data$Date,
        y = .data$Score,
        color = .data$Race_Ethnicity
    )
) +
    ggplot2::geom_point(
        mapping = ggplot2::aes(size = .data$Count),
        data = student_scores |>
            dplyr::filter(
                .data$Grade_Level == "3",
                .data$Calendar_Days >= 0,
                .data$Date < lubridate::ymd("2025-06-12")
            ) |>
            dplyr::summarize(
                Score = mean(.data$Score),
                Count = dplyr::n_distinct(.data$Student_ID),
                .by = c("School", "Race_Ethnicity", "Date")
            ),
        alpha = 1.0/3.0
    ) +
    ggplot2::geom_line(
        data = dplyr::filter(orf_predictions,
                             .data$Grade_Level == "3"),
        alpha = 0.9,
        linewidth = 1,
        lineend = "round"
    ) +
    ggplot2::scale_color_manual(
        values = hiRx::higher_ex_pal("race")(5)
    ) +
    ggplot2::facet_wrap(
        ggplot2::vars(.data$School)
    ) +
    ggplot2::labs(
        title = "3rd grade Amira ORF scores"
    ) +
    ggplot2::theme_light()


