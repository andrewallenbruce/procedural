# load libraries ----------------------------------------------------------

library(xmlrectr)
library(collapse)
library(cheapr)
library(vctrs)
library(purrr)

# data rectangling --------------------------------------------------------

xml <- fs::path(
  "C:/Users/Andrew/Downloads",
  "zip-file-2-2027-code-tables-and-index"
)
ind_xml <- fs::path(xml, "icd10pcs_index_2027", ext = "xml")
ind_prof <- xml_profile(rows = "ICD10PCS.index/letter")
ind_spec <- compile_xml_profile(ind_prof, ind_xml)
ind_rect <- rectangle_xml(ind_xml, ind_spec, parallel = TRUE)
pcs_index <- ss(ind_rect, j = c(2L, 4:6, 8:14))

# use_data ----------------------------------------------------------------

usethis::use_data(pcs_index, overwrite = TRUE)

# data transformation -----------------------------------------------------
x = pcs_index
x <- col_c(num_vars(x), cat_vars(x)) |>
  rsplit(~record_index) |>
  rlang::set_names(c("3", LETTERS))

x$F |> print(n = 100)

num_vars(x) |> _$record_index |> unique()
