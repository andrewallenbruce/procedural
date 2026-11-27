library(procedural)
pcs_order <- process_order()
usethis::use_data(pcs_order, overwrite = TRUE)

# data transformation -----------------------------------------------------
o <- procedural::pcs_order
tbl <- cheapr::row_c(
  collapse::ss(o, o$valid %==% 0L, c(1L, 3L)),
  collapse::ss(o, collapse::fmax(o$order), c(1L, 3L))
)
tbl$iv <- ivs::iv(tbl$order, cheapr::lag_(tbl$order, -1L))
tbl <- vctrs::vec_slice(tbl, tbl$order != collapse::fmax(tbl$order)) |>
  rlang::set_names(c("order", "table", "iv"))

sys <- collapse::av(tbl, system = substr(tbl$table, 1L, 2L))
sys <- collapse::ss(sys, j = c(1L, 4L)) |>
  collapse::gby(system) |>
  collapse::fsummarise(order = collapse::fmin(order))

sys$iv <- ivs::iv(sys$order, cheapr::lag_(sys$order, -1L))
sys$iv[collapse::fnrow(sys)] <- ivs::iv(80171L, 80174L)
sys |> tail()

o2 <- dplyr::left_join(o, tbl)
o2$table <- vctrs::vec_fill_missing(o2$table)
collapse::colorderv(o2, c("order", "table"))
