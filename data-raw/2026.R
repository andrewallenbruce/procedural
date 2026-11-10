library(xmlrectr)
library(zuxml)

pcs_dir <- fs::path("C:/Users/Andrew/Downloads")
pcs_xml <- fs::path(pcs_dir, "zip-file-2-2027-code-tables-and-index")
pcs_index <- fs::path(pcs_xml, "icd10pcs_index_2027", ext = "xml")
xsd_index <- fs::path(pcs_xml, "icd10pcs_index", ext = "xsd")
pcs_table <- fs::path(pcs_xml, "icd10pcs_tables_2027", ext = "xml")
xsd_table <- fs::path(pcs_xml, "icd10pcs_tables", ext = "xsd")
pcs_define <- fs::path(pcs_xml, "icd10pcs_definitions_2027", ext = "xml")
xsd_define <- fs::path(pcs_xml, "icd10pcs_definitions", ext = "xsd")


xmlrectr::inspect_xsd(xsd_index)
prop_pcs_index <- xmlrectr::propose_xml_profile(pcs_index, xsd = xsd_index)
prop_pcs_index
prop_pcs_rows <- xmlrectr::review_xml_proposal(prop_pcs_index, "rows")
prop_pcs_rows |> str()
prop_pcs_ids <- xmlrectr::review_xml_proposal(prop_pcs_index, "ids")
prop_pcs_ids |> str()
prop_pcs_fields <- xmlrectr::review_xml_proposal(prop_pcs_index, "fields")
prop_pcs_fields |> str()
xmlrectr::review_xml_proposal(prop_pcs_index, "xsd")
prop_pcs_profile <- xmlrectr::xml_profile(rows = "ICD10PCS.index/letter")
spec_pcs_profile <- xmlrectr::compile_xml_profile(prop_pcs_profile, pcs_index)
xmlrectr::review_rectangle(spec_pcs_profile)
pcs_index_rect <- xmlrectr::rectangle_xml(
  pcs_index,
  spec_pcs_profile,
  parallel = TRUE
)
pcs_index_rect |> str()
readr::write_csv(
  pcs_index_rect,
  fs::path(pcs_xml, "icd10pcs_index_2027", ext = "csv")
)

cheapr::overview(pcs_index_rect)
collapse::num_vars(pcs_index_rect)
collapse::cat_vars(pcs_index_rect)
ind_split <- collapse::ss(pcs_index_rect, j = c(2, 4:6, 8, 10:15))
ind_split <- cheapr::col_c(
  collapse::num_vars(ind_split),
  collapse::cat_vars(ind_split)
)
ind <- ind_split |>
  collapse::rsplit(~record_index) |>
  rlang::set_names(c("3", LETTERS))

ind$A |>
  # collapse::sbt(field == "level") |>
  print(n = 100)
