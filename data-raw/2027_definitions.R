library(xmlrectr)
library(zuxml)

pcs_xml <- fs::path(
  "C:/Users/Andrew/Downloads",
  "zip-file-2-2027-code-tables-and-index"
)
define_xml <- fs::path(pcs_xml, "icd10pcs_definitions_2027", ext = "xml")
define_xsd <- fs::path(pcs_xml, "icd10pcs_definitions", ext = "xsd")
define_proposal <- xmlrectr::propose_xml_profile(define_xml, xsd = define_xsd)
define_profile <- xmlrectr::xml_profile(rows = "ICD10PCS.definitions/section")
define_spec <- xmlrectr::compile_xml_profile(define_profile, define_xml)
define_rect <- xmlrectr::rectangle_xml(define_xml, define_spec, parallel = TRUE)
pcs_definitions <- collapse::ss(define_rect, j = c(2L, 4:6, 8:14))
usethis::use_data(pcs_definitions, overwrite = TRUE)

def_ <- collapse::ss(
  pcs_definitions,
  j = c(1L, 3L, 2L, 4:5)
) |>
  collapse::rsplit(~record_index)

make_includes <- function(x, d) {
  a <- collapse::ss(x, x$entity %==% "axis") |>
    _$value |>
    as.list() |>
    rlang::set_names(c("axis", "title")) |>
    list2DF()

  d <- cheapr::col_c(d, a)

  b <- collapse::ss(x, x$entity %!=% "axis")
  b$field <- cheapr::if_else_(grepl("includes$", b$entity), "includes", "value")
  b <- collapse::ss(b, j = -1L)
  b <- collapse::av(
    b,
    entity = cheapr::if_else_(b$field == "value", b$value, NA_character_),
    pos = "front"
  )
  b$entity <- vctrs::vec_fill_missing(b$entity)
  b <- collapse::ss(b, b$field %!=% "value")
  cheapr::col_c(d, b)
}

make_definition <- function(x, d) {
  a <- collapse::ss(x, x$entity %==% "axis") |>
    _$value |>
    as.list() |>
    rlang::set_names(c("axis", "title")) |>
    list2DF()

  d <- cheapr::col_c(d, a)
  b <- collapse::ss(x, x$entity %!=% "axis", -1L)
  cheapr::col_c(
    d,
    cheapr::new_df(
      value = collapse::ss(b, b$field %==% "value") |> _$value,
      definition = collapse::ss(b, b$field %==% "definition") |> _$value
    )
  )
}

process_definitions <- function(x) {
  df <- collapse::ss(
    x,
    x$entity %==% "section"
  ) |>
    _$value |>
    as.list() |>
    rlang::set_names(c("section", "name")) |>
    list2DF()

  x <- collapse::ss(x, x$entity %!=% "section", -1L)
  x <- collapse::av(x, entry = cumsum(x$field == "pos"), pos = "front")
  x <- collapse::rsplit(x, ~entry)

  purrr::map(x, \(x) {
    if (collapse::anyv(grepl("includes$", x$entity), TRUE)) {
      make_includes(x, df)
    } else {
      make_definition(x, df)
    }
  })
}

process_definitions(def_)
x$`1` |> print(n = Inf)
x <- def_[["1"]] |> print(n = Inf)

def2 <- collapse::ss(def_[["2"]], 5:33, 3:4)
def3 <- collapse::ss(def_[["2"]], 36:47, 3:4)

df_1 <- cheapr::new_df(
  section = "1",
  name = "Obstetrics",
  axis = 3L,
  title = "Operation",
  value = collapse::ss(def2, def2$field %==% "value") |> _$value,
  definition = collapse::ss(def2, def2$field %==% "definition") |> _$value
) |>
  collapse::qTBL()

df_2 <- cheapr::new_df(
  section = "1",
  name = "Obstetrics",
  axis = 5L,
  title = "Approach",
  value = collapse::ss(def3, def3$field %==% "value") |> _$value,
  definition = collapse::ss(def3, def3$field %==% "definition") |> _$value
) |>
  collapse::qTBL()

definitions_obstetrics <- vctrs::vec_rbind(df_1, df_2)
