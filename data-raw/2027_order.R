## code to prepare `2027-txt` dataset goes here
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
    desc_abbr = c(16L, 76L),
    desc_full = c(77L, NA_integer_)
  ),
  show_col_types = FALSE,
  col_types = "icicc"
)
class(pcs_order) <- setdiff(class(pcs_order), "spec_tbl_df")
pcs_order
usethis::use_data(pcs_order, overwrite = TRUE)
