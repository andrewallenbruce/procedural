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
tbl_xsd <- fs::path(xml, "icd10pcs_tables", ext = "xsd")
tbl_prop <- propose_xml_profile(tbl_xml, xsd = tbl_xsd)
tbl_prof <- xml_profile(rows = "ICD10PCS.tabular/pcsTable")
tbl_spec <- compile_xml_profile(tbl_prof, tbl_xml)
tbl_rect <- rectangle_xml(tbl_xml, tbl_spec, parallel = TRUE)
pcs_tables <- ss(tbl_rect, j = c(2L, 4:6, 8:14))

# use_data ----------------------------------------------------------------

usethis::use_data(pcs_tables, overwrite = TRUE)

# data transformation -----------------------------------------------------

tbl = pcs_tables

ss(tbl, tbl$record_index == 1L) |>
  rsplit(~entity_index) |>
  print(n = 127)
