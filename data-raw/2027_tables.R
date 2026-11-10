library(xmlrectr)
library(zuxml)
pcs_xml <- fs::path(
  "C:/Users/Andrew/Downloads",
  "zip-file-2-2027-code-tables-and-index"
)
table_xml <- fs::path(pcs_xml, "icd10pcs_tables_2027", ext = "xml")
table_xsd <- fs::path(pcs_xml, "icd10pcs_tables", ext = "xsd")

xmlrectr::inspect_xsd(table_xsd)

table_proposal <- xmlrectr::propose_xml_profile(table_xml, xsd = table_xsd)
xmlrectr::review_xml_proposal(table_proposal, "rows")
xmlrectr::review_xml_proposal(table_proposal, "ids")
xmlrectr::review_xml_proposal(table_proposal, "fields")
xmlrectr::review_xml_proposal(table_proposal, "xsd")
table_profile <- xmlrectr::xml_profile(rows = "ICD10PCS.tabular/pcsTable")
table_spec <- xmlrectr::compile_xml_profile(table_profile, table_xml)
xmlrectr::review_rectangle(table_spec)
table_rect <- xmlrectr::rectangle_xml(table_xml, table_spec, parallel = TRUE)
pcs_tables <- collapse::ss(table_rect, j = c(2L, 4:6, 8:14))
usethis::use_data(pcs_tables, overwrite = TRUE)

pcs_tables

# cheapr::col_c(
#   collapse::num_vars(pcs_tables),
#   collapse::cat_vars(pcs_tables)
# ) |>

collapse::ss(pcs_tables, pcs_tables$record_index == 1L) |>
  collapse::rsplit(~entity_index) |>
  print(n = 127)
