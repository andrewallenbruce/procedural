library(xmlrectr)
library(zuxml)

pcs_xml <- fs::path(
  "C:/Users/Andrew/Downloads",
  "zip-file-2-2027-code-tables-and-index"
)
define_xml <- fs::path(pcs_xml, "icd10pcs_definitions_2027", ext = "xml")
define_xsd <- fs::path(pcs_xml, "icd10pcs_definitions", ext = "xsd")

xmlrectr::inspect_xsd(define_xsd)

define_proposal <- xmlrectr::propose_xml_profile(define_xml, xsd = define_xsd)
xmlrectr::review_xml_proposal(define_proposal, "rows")$rows
xmlrectr::review_xml_proposal(define_proposal, "ids")
xmlrectr::review_xml_proposal(define_proposal, "fields")
xmlrectr::review_xml_proposal(define_proposal, "xsd")
define_profile <- xmlrectr::xml_profile(rows = "ICD10PCS.definitions/section")
define_spec <- xmlrectr::compile_xml_profile(define_profile, define_xml)
xmlrectr::review_rectangle(define_spec)
define_rect <- xmlrectr::rectangle_xml(define_xml, define_spec, parallel = TRUE)
pcs_definitions <- collapse::ss(define_rect, j = c(1:2, 4:6, 8:15))
usethis::use_data(pcs_definitions, overwrite = TRUE)
