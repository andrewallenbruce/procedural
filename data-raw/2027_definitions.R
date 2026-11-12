library(xmlrectr)
library(zuxml)

# data rectangling --------------------------------------------------------

xml <- fs::path(
  "C:/Users/Andrew/Downloads",
  "zip-file-2-2027-code-tables-and-index"
)
def_xml <- fs::path(xml, "icd10pcs_definitions_2027", ext = "xml")
def_xsd <- fs::path(xml, "icd10pcs_definitions", ext = "xsd")
def_prop <- xmlrectr::propose_xml_profile(def_xml, xsd = def_xsd)
def_prof <- xmlrectr::xml_profile(rows = "ICD10PCS.definitions/section")
def_spec <- xmlrectr::compile_xml_profile(def_prof, def_xml)
def_rect <- xmlrectr::rectangle_xml(def_xml, def_spec, parallel = TRUE)

pcs_definitions <- collapse::ss(def_rect, j = c(2L, 4:6, 8:14))
usethis::use_data(pcs_definitions, overwrite = TRUE)

pcs_definitions |>
  print(n = 100)

# data transformation -----------------------------------------------------

pcs_definitions$section <- cheapr::if_else_(
  pcs_definitions$entity == "section" &
    pcs_definitions$value_kind == "attribute",
  pcs_definitions$value,
  NA_character_
)
pcs_definitions$section <- vctrs::vec_fill_missing(pcs_definitions$section)
pcs_definitions$name <- cheapr::lag_(
  cheapr::if_else_(
    pcs_definitions$entity == "section" & pcs_definitions$field == "title",
    pcs_definitions$value,
    NA_character_
  ),
  -1L
)
pcs_definitions$name <- vctrs::vec_fill_missing(pcs_definitions$name)
pcs_definitions$axis <- cheapr::if_else_(
  pcs_definitions$entity == "axis" & pcs_definitions$value_kind == "attribute",
  pcs_definitions$value,
  NA_character_
)
pcs_definitions$title <- cheapr::lag_(
  cheapr::if_else_(
    pcs_definitions$entity == "axis" & pcs_definitions$field == "title",
    pcs_definitions$value,
    NA_character_
  ),
  -1L
)
pcs_definitions <- collapse::colorderv(
  pcs_definitions,
  c("section", "name", "axis", "title")
)
pcs_definitions <- collapse::ss(
  pcs_definitions,
  pcs_definitions$entity %!=% "section",
  j = c(1:6, 8:9)
) |>
  collapse::rsplit(~record_index)

pcs_definitions <- purrr::map(pcs_definitions, \(x) {
  x[["axis"]] <- vctrs::vec_fill_missing(x[["axis"]])
  x[["title"]] <- vctrs::vec_fill_missing(x[["title"]])
  x <- collapse::ss(x, x[["entity"]] %!=% "axis")
  x[["field"]] <- cheapr::if_else_(
    x[["entity"]] == "axis/terms/includes",
    "includes",
    x[["field"]]
  )
  x <- collapse::av(
    x,
    term = cheapr::if_else_(
      x[["entity"]] == "axis/terms/title",
      1L,
      NA_character_
    ),
    entry = cumsum(x[["entity"]] == "axis/terms/title"),
    pos = "front"
  )
  collapse::av(x, run = vctrs::vec_identify_runs(x[["term"]]), pos = "front")
})

collapse::ss(pcs_definitions$`1`, pcs_definitions$`1`$term == 1L) |>
  print(n = 200)

pcs_definitions$`1` |> print(n = 200)
