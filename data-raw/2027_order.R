# load libraries ----------------------------------------------------------

library(xmlrectr)
library(collapse)
library(cheapr)
library(vctrs)
library(purrr)

# data rectangling --------------------------------------------------------

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
pcs_order <- col_c(num_vars(pcs_order), cat_vars(pcs_order))

# use_data ----------------------------------------------------------------

usethis::use_data(pcs_order, overwrite = TRUE)

# data transformation -----------------------------------------------------
o = pcs_order
o_table <- row_c(ss(o, o$valid %==% 0L), ss(o, fmax(o$order)))
o_table$table <- ivs::iv(o_table$order, lag_(o_table$order, -1L))

o_table <- sset(
  o_table,
  o_table$order != fmax(o_table$order),
  j = c(1L, 6L, 2:3, 5L)
)

o_system <- o_table

o_system$system <- substr(o_system$code, 1L, 2L)

ss(o_system, j = c(1L, 6L, 4:5)) |>
  fgroup_by(system) |>
  fsummarise(
    order = fmin(order),
    description_long = fslice(description_long)
  )

o2 <- dplyr::left_join(o, o_table)
o2$table <- vec_fill_missing(o2$table)
colorderv(o2, c("order", "table"))
