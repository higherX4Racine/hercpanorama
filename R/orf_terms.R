ORF_EFFECT_NAMES <- c(
    "School_Type",
    "Grade_Level",
    "Race_Ethnicity",
    "Economic_Status",
    "English_Learner"
)

nth_order_terms <- function(.n, .effects) {
    .effects |>
        combn(.n, simplify = FALSE) |>
        purrr::map_chr(
            \(.) stringr::str_c(., collapse = ":")
        ) |>
        tibble::tibble(
            Term = _,
            Order = .n
        )
}

add_appearances <- function(.term_data, .effect_name) {
    dplyr::mutate(.term_data,
                  "{.effect_name}" := stringr::str_detect(.data$Term,
                                                          .effect_name))
}

orf_scores <- readRDS(hiRx::input_path("Iterations",
                                       "Panoramel",
                                       "orf_scores_tmp.rds"))

orf_effects <- orf_scores |>
    dplyr::select(
        tidyselect::all_of(ORF_EFFECT_NAMES)
    ) |>
    dplyr::summarize(
        dplyr::across(tidyselect::everything(),
                      dplyr::n_distinct)
    ) |>
    tidyr::pivot_longer(
        cols = tidyselect::everything(),
        names_to = "Effect",
        values_to = "Levels"
    ) |>
    dplyr::mutate(
        D_of_F = .data$Levels - 1L
    ) |>
    dplyr::bind_rows(
        tibble::tibble(
            Effect = "Calendar_Days",
            Levels = NA,
            D_of_F = 1
        )
    )

orf_terms <- orf_effects$Effect |>
    purrr::reduce(
        add_appearances,
        .init = (1:4) |>
            purrr::map(
                \(.n) nth_order_terms(.n,
                                      orf_effects$Effect)
            ) |>
            purrr::list_rbind()
    ) |>
    dplyr::filter(
        !((.data$Economic_Status | .data$English_Learner)
          & .data$Race_Ethnicity)
    )


#    purrr::list_rbind() |>
#    dplyr::rowwise() |>
#    dplyr::mutate(
#        Order = (\(.) sum(nchar(.) > 0, na.rm = TRUE))(
#            dplyr::c_across(tidyselect::any_of(LETTERS))
#        ),
#        D_of_F = (\(.) sum(orf_effects[.], na.rm = TRUE))(
#            dplyr::c_across(tidyselect::any_of(LETTERS))
#        ),
#        Term = (\(.) paste(.[!is.na(.)], collapse = ":"))(
#            dplyr::c_across(tidyselect::any_of(LETTERS))
#        )
#    ) |>
#    dplyr::ungroup() |>
#    dplyr::select(
#        "Term",
#        "Order",
#        "D_of_F"
#    ) |>
#    dplyr::arrange(
#        .data$Order,
#        .data$D_of_F
#    )

# nuthin <- tibble::tibble(Term = "",
#                          Order = 0L,
#                          D_of_F = 0L)
#
# less_than_nothing <- tibble::tibble(Term = character(),
#                                     Order = integer(),
#                                     D_of_F = integer())
#
# kids_or_nothing <- function(.x, .term, .order) {
#     if (nchar(.term) == 0)
#         return(nuthin)
#     .x |>
#         dplyr::filter(.data$Order == .order + 1,
#                       stringr::str_detect(.data$Term, .term)
#         ) |>
#         dplyr::bind_rows(
#             nuthin
#         )
# }

# parents <- function(.x, .term, .order) {
#     if (nchar(.term) == 0)
#         return(nuthin)
#     .regex = stringr::str_replace_all(.term, ":", "|")
#     .x |>
#         dplyr::filter(
#             .data$Order == .order - 1,
#             stringr::str_detect(.x$Term, .regex),
#             stringr::str_detect(.term,
#                                 stringr::str_replace_all(.x$Term,
#                                                          ":",
#                                                          ":(.+:)?"))
#         ) |>
#         dplyr::bind_rows(
#             nuthin
#         )
# }

# recompute_dimensions <- function(.x) {
#     .x |>
#         dplyr::rowwise() |>
#         dplyr::mutate(
#             Order = max(dplyr::c_across(tidyselect::contains("Order"))),
#             D_of_F = sum(dplyr::c_across(tidyselect::contains("D_of_F")))
#         ) |>
#         dplyr::ungroup()
# }

# expand_children <- function(.x, .terms_df, .target_name, .result_name) {
#     .x |>
#         dplyr::mutate(
#             "{.result_name}" := purrr::map2(
#                 .data[[.target_name]],
#                 .data$Order,
#                 \(.term, .order) kids_or_nothing(.terms_df, .term, .order)
#             )
#         ) |>
#         tidyr::unnest(
#             cols = tidyselect::all_of(.result_name),
#             names_sep = " "
#         ) |>
#         recompute_dimensions() |>
#         dplyr::select(
#             tidyselect::all_of(names(.x)),
#             "{.result_name}" := paste(.result_name, "Term"),
#         ) |>
#         dplyr::relocate(
#             tidyselect::all_of(.result_name),
#             .before = "Order"
#         )
# }

# expand_parents <- function(.x, .terms_df, .prefix, .result_name) {
#     .keys <- .prefix |>
#         stringr::str_c(
#             c("Term", "Order"), sep = " "
#         ) |>
#         stringr::str_squish()
#     .x |>
#         dplyr::mutate(
#             "{.result_name}" := purrr::map2(
#                 .data[[.keys[1]]],
#                 .data[[.keys[2]]],
#                 \(.term, .order) parents(.terms_df, .term, .order)
#             )
#         )
# }

# orf_parents <- orf_terms |>
#     dplyr::mutate(
#         Parent = purrr::map2(
#             .data$Term, .data$Order,
#             \(.t, .o) orf_terms |>
#                 parents(.t, .o) |>
#                 dplyr::mutate(
#                     Grandparent = purrr::map2(
#                         .data$Term, .data$Order,
#                         \(.t, .o) parents(orf_terms, .t, .o)
#                     )
#                 ) |>
#                 tidyr::unnest(
#                     cols = "Grandparent",
#                     names_sep = " "
#                 ) |>
#                 dplyr::rename(
#                     `Parent Term` = "Term",
#                     `Parent Order` = "Order",
#                     `Parent D_of_F` = "D_of_F"
#                 )
#         )
#     ) |>
#     tidyr::unnest(
#         cols = "Parent"
#     )

#    expand_parents(
#        orf_terms,
#        "",
#        "Parent"
#    ) |>
#    expand_parents(
#        orf_terms,
#        "Parent",
#        "Grandparent"
#    )

#  orf_models <- orf_terms |>
#      dplyr::filter(
#          .data$Order == 1
#      ) |>
#      expand_children(
#          orf_terms,
#          "Term",
#          "Child"
#      ) |>
#      expand_children(
#          orf_terms,
#          "Child",
#          "Grandchild"
#      ) |>
#      dplyr::arrange(
#          .data$Order,
#          .data$D_of_F,
#          .data$Term
#      )
