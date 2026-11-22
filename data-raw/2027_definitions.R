library(procedural)

# definitions -------------------------------------------------------------

x <- process_definitions()
y <- collapse::ss(x, x$field %==% "Explanation", colnames(x) %!=% "field")
# y <- collapse::rnm(y, value = "explanation")

x <- collapse::ss(x, x$field %==% "Definition", colnames(x) %!=% "field")
x <- collapse::rnm(x, value = "definition")

x <- collapse::join(x, y, on = c("entry", "section", "axis", "name", "term"))
x$definition <- cheapr::paste_(x$definition, ".")
x$definition <- cheapr::if_else_(
  !cheapr::is_na(x$value),
  cheapr::paste_(x$definition, " ", x$value, "."),
  x$definition
)
pcs_definitions <- collapse::ss(x, j = -7L)

usethis::use_data(pcs_definitions, overwrite = TRUE)

# includes ----------------------------------------------------------------

x <- process_includes()
pcs_includes <- x
usethis::use_data(pcs_includes, overwrite = TRUE)

# table_definition --------------------------------------------------------

# start with the parsed 2027 tables XML file
x <- process_tables(xml = TRUE)
d <- collapse::ss(x, x$field %==% "definition")
i <- whichv_(
  x$record_index %in_%
    cheapr::unique_(d$record_index) &
    x$entity_index %in_% cheapr::unique_(d$entity_index)
)

x <- collapse::ss(x, i)
i <- whichv_(x$entity == "axis" & x$field != "values")
x <- collapse::ss(x, i, c(1L, 4:5))

extract_field <- function(x, name) {
  x <- collapse::ss(x, x$field %==% name, -2L)
  collapse::setrename(x, value = name)
  if (name == "pos") {
    collapse::settfmv(x, "pos", as.integer)
  }
  return(x)
}

tables_definition <- cheapr::fast_df(
  entry = pos$record_index,
  pos = extract_field(x, "pos"),
  title = extract_field(x, "title"),
  code = extract_field(x, "code"),
  label = extract_field(x, "label"),
  definition = extract_field(x, "definition")
) |>
  collapse::qTBL()

usethis::use_data(tables_definition, overwrite = TRUE)
