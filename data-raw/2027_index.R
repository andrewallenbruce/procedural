# load libraries ----------------------------------------------------------

library(collapse)
library(cheapr)
library(vctrs)
library(purrr)

# data rectangling --------------------------------------------------------

index_file <- fs::path(
  "C:/Users/Andrew/Downloads",
  "zip-file-2-2027-code-tables-and-index",
  "icd10pcs_index_2027",
  ext = "xml"
)

x <- process_index_file(index_file)

# use_data ----------------------------------------------------------------

usethis::use_data(pcs_index, overwrite = TRUE)

# data transformation -----------------------------------------------------
x <- procedural::pcs_index
x <- cheapr::col_c(
  collapse::num_vars(x),
  collapse::cat_vars(x)
) |>
  collapse::rsplit(~record_index) |>
  rlang::set_names(c("3", LETTERS))

x$F |> print(n = 100)

collapse::num_vars(x) |>
  _$record_index |>
  cheapr::unique_()
