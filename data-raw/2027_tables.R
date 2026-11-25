library(procedural)

# data rectangling --------------------------------------------------------

x <- process_tables()

# add tables from order file ----------------------------------------------

o <- process_order()
x <- collapse::ss(procedural::pcs_order, procedural::pcs_order$valid %==% 0L)
x <- collapse::av(x, table = collapse::fcumsum(x$valid == 0L), pos = "front")
x <- collapse::ss(x, j = c(1L, 3L, 4L, 6L))
x <- collapse::rnm(x, pos = "valid", label = "description_long")
x <- collapse::av(x, title = rep.int("Table", nrow_(x)), pos = "front")
x <- collapse::colorderv(x, c("table", "pos", "title"))
tbl <- collapse::rowbind(tbl, x) |> collapse::roworderv(c("table", "pos"))

# use_data ----------------------------------------------------------------

usethis::use_data(pcs_tables, overwrite = TRUE)
