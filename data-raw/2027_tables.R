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
tbl_xml <- fs::path(xml, "icd10pcs_tables_2027", ext = "xml")
# tbl_xsd <- fs::path(xml, "icd10pcs_tables", ext = "xsd")
# tbl_prop <- propose_xml_profile(tbl_xml, xsd = tbl_xsd)
tbl_prof <- xml_profile(rows = "ICD10PCS.tabular/pcsTable")
tbl_spec <- compile_xml_profile(tbl_prof, tbl_xml)
tbl_rect <- rectangle_xml(tbl_xml, tbl_spec, parallel = TRUE)
pcs_tables <- ss(tbl_rect, j = c(2L, 4:6, 8:14))

# use_data ----------------------------------------------------------------

usethis::use_data(pcs_tables, overwrite = TRUE)

# data transformation -----------------------------------------------------

x <- ss(
  pcs_tables,
  pcs_tables$field %!=% "definition",
  j = 1:6,
  check = FALSE
)

x$field <- if_else_(
  x$field == "label/code",
  "code",
  x$field
)

x

e <- ss(x, x$record_index %iin% 1:3) |> rsplit(~record_index)

b <- e$`1` |> rsplit(~entity_index)

b$`1` |> print(n = Inf)

b0 <- ss(
  b$`1`,
  b$`1`$entity == "axis" & b$`1`$field != "values",
  j = 2:3
) |>
  datawizard::data_rotate(colnames = TRUE) |>
  qTBL() |>
  collapse::rnm(label = "value")

b0 <- av(b0, record = 1L, entry = NA_integer_, pos = "front")

b1 <- ss(
  b$`1`,
  b$`1`$entity != "axis" & !b$`1`$field %in% c("codes", "values"),
  j = 2:3
)

b1 <- av(b1, entry = cumsum(b1$field == "pos")) |>
  tidyr::pivot_wider(
    names_from = field,
    values_from = value,
    values_fn = list
  ) |>
  tidyr::unnest_longer(c(pos, title, code, value))

vctrs::vec_rbind(b0, b1)
