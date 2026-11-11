pcs_order <- readr::read_fwf(
  fs::path(
    "C:/Users/Andrew/Downloads",
    "zip-file-4-2027-icd-10-pcs-order-file-long-and-abbreviated-titles",
    "icd10pcs_order_2027",
    ext = "txt"
  ),
  readr::fwf_cols(
    order = c(1L, 5L),
    code = c(6L, 13L),
    valid = 14:15,
    description_short = c(16L, 76L),
    description_long = c(77L, NA_integer_)
  ),
  show_col_types = FALSE,
  col_types = "icicc"
)
class(pcs_order) <- setdiff(class(pcs_order), "spec_tbl_df")
pcs_order <- cheapr::col_c(
  collapse::num_vars(pcs_order),
  collapse::cat_vars(pcs_order)
)
usethis::use_data(pcs_order, overwrite = TRUE)

library(collapse)
pcs_order_table <- cheapr::row_c(
  collapse::ss(pcs_order, pcs_order$valid %==% 0L),
  collapse::ss(pcs_order, collapse::fmax(pcs_order$order))
)

pcs_order_table$table <- ivs::iv(
  pcs_order_table$order,
  cheapr::lag_(pcs_order_table$order, -1L)
)
pcs_order_table <- cheapr::sset(
  pcs_order_table,
  pcs_order_table$order != collapse::fmax(pcs_order_table$order),
  j = c(1L, 6L, 2L, 3L, 5L)
)
pcs_order_system <- pcs_order_table

pcs_order_system$system <- substr(pcs_order_system$code, 1, 2)
collapse::ss(pcs_order_system, j = c(1, 6, 4:5)) |>
  collapse::fgroup_by(system) |>
  collapse::fsummarise(
    order = collapse::fmin(order),
    description_long = collapse::fslice(description_long)
  )

pcs_order2 <- dplyr::left_join(pcs_order, pcs_order_table)
pcs_order2$table <- vctrs::vec_fill_missing(pcs_order2$table)
pcs_order2 |> collapse::colorderv(c("order", "table"))
