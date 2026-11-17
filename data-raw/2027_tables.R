# load libraries ----------------------------------------------------------

library(collapse)
library(cheapr)
library(vctrs)
library(purrr)

# data rectangling --------------------------------------------------------

xml <- fs::path(
  "C:/Users/Andrew/Downloads",
  "zip-file-2-2027-code-tables-and-index",
  "icd10pcs_tables_2027",
  ext = "xml"
)
prof <- xmlrectr::xml_profile(rows = "ICD10PCS.tabular/pcsTable")
spec <- xmlrectr::compile_xml_profile(prof, sample = xml)
rect <- xmlrectr::rectangle_xml(file = xml, spec, parallel = TRUE)
x <- collapse::ss(rect, j = c(2L, 4:6, 8:14))
# 375.43 sec elapsed

# data transformation -----------------------------------------------------
x <- procedural::pcs_tables
x <- collapse::ss(x, x$field %!=% "definition", c(1:2, 4:5))
x <- collapse::rnm(x, table = "record_index")
x$field <- cheapr::if_else_(
  x$field == "label/code",
  "code",
  x$field
)
x <- collapse::rsplit(x, ~table, keep.by = TRUE) # 918 tables

process_table <- function(x) {
  table <- collapse::ss(
    x,
    x$entity == "axis" & x$field != "values",
    3:4
  ) |>
    collapse::rsplit(~field) |>
    collapse::qTBL() |>
    collapse::colorderv(c("pos", "title", "code", "label"))

  rows <- collapse::ss(
    x,
    x$entity %!in_% c("axis", "pcsRow") & x$field != "values",
    3:4
  )

  rows$field <- cheapr::if_else_(
    rows$field == "value",
    "label",
    rows$field
  )

  rows <- collapse::av(rows, row = cumsum(rows$field == "pos"), pos = "front")
  rows <- collapse::rsplit(rows, ~row)
  rows <- purrr::map(rows, function(x) {
    cheapr::col_c(
      cheapr::fast_df(
        pos = collapse::ss(x, x$field %==% "pos") |> _$value,
        title = collapse::ss(x, x$field %==% "title") |> _$value
      ),
      cheapr::fast_df(
        code = collapse::ss(x, x$field %==% "code") |> _$value,
        label = collapse::ss(x, x$field %==% "label") |> _$value
      )
    )
  }) |>
    collapse::rowbind() |>
    collapse::qTBL()

  res <- collapse::rowbind(table, rows)
  collapse::av(
    res,
    table = rep.int(x$table[1L], collapse::fnrow(res)),
    pos = "front"
  )
}

x <- purrr::map(x, process_table) |>
  collapse::rowbind()

x$pos <- as.integer(x$pos)
pcs_tables <- x

x <- collapse::ss(procedural::pcs_order, procedural::pcs_order$valid %==% 0L)
x <- collapse::av(x, table = collapse::fcumsum(x$valid == 0L), pos = "front")
x <- collapse::ss(x, j = c(1L, 3L, 4L, 6L))
x <- collapse::rnm(x, pos = "valid", label = "description_long")
x <- collapse::av(
  x,
  title = rep.int("Table", nrow_(x)),
  pos = "front"
)
x <- collapse::colorderv(x, c("table", "pos", "title"))
pcs_tables <- collapse::rowbind(pcs_tables, x) |>
  collapse::roworderv(c("table", "pos"))

# use_data ----------------------------------------------------------------

usethis::use_data(pcs_tables, overwrite = TRUE)
