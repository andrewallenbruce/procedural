library(xmlrectr)
library(zuxml)

pcs_xml <- fs::path(
  "C:/Users/Andrew/Downloads",
  "zip-file-2-2027-code-tables-and-index"
)
index_xml <- fs::path(pcs_xml, "icd10pcs_index_2027", ext = "xml")
index_xsd <- fs::path(pcs_xml, "icd10pcs_index", ext = "xsd")
xmlrectr::inspect_xsd(index_xsd)
index_proposal <- xmlrectr::propose_xml_profile(index_xml, xsd = index_xsd)
xmlrectr::review_xml_proposal(index_proposal, "rows")
xmlrectr::review_xml_proposal(index_proposal, "ids")
xmlrectr::review_xml_proposal(index_proposal, "fields")
xmlrectr::review_xml_proposal(index_proposal, "xsd")
index_profile <- xmlrectr::xml_profile(rows = "ICD10PCS.index/letter")
index_spec <- xmlrectr::compile_xml_profile(index_profile, index_xml)
xmlrectr::review_rectangle(index_spec)
index_rect <- xmlrectr::rectangle_xml(index_xml, index_spec, parallel = TRUE)
pcs_index <- collapse::ss(index_rect, j = c(2L, 4:6, 8:14))
usethis::use_data(pcs_index, overwrite = TRUE)

index_split <- cheapr::col_c(
  collapse::num_vars(pcs_index),
  collapse::cat_vars(pcs_index)
) |>
  collapse::rsplit(~record_index) |>
  rlang::set_names(c("3", LETTERS))

index_split$F |>
  # collapse::sbt(field == "level") |>
  print(n = 100)

collapse::num_vars(pcs_index) |>
  _$record_index |>
  unique()
