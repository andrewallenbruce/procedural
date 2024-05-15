definitions(axis = "3") |>
  dplyr::count(section, value) |>
  dplyr::select(section, value) |>
  tidyr::nest(values = c(value)) |>
  dplyr::mutate(values = purrr::map(values, ~ .x$value)) |>
  dplyr::mutate(values = purrr::map_chr(values, ~ paste0("'", .x, "'", collapse = ", ")),
                section = purrr::map_chr(section, ~ paste0("'", .x, "'", collapse = ", "))) |>
  dplyr::mutate(values = paste("c(", values, ")", sep = ""),
                section = paste0(section, " =")) |>
  tidyr::unite("definition", section, values, sep = " ")

includes(axis = "4") |>
  dplyr::count(section, label) |>
  dplyr::select(section, label) |>
  tidyr::nest(labels = c(label)) |>
  dplyr::mutate(labels = purrr::map(labels, ~ .x$label)) |>
  dplyr::mutate(labels = purrr::map_chr(labels, ~ paste0("'", .x, "'", collapse = ", ")),
                section = purrr::map_chr(section, ~ paste0("'", .x, "'", collapse = ", "))) |>
  dplyr::mutate(labels = paste("c(", labels, ")", sep = ""),
                section = paste0(section, " =")) |>
  tidyr::unite("includes", section, labels, sep = " ")

pcs("F14Z01Z")
pcs("0LQV3ZZ")
pcs("5A02210")
pcs("0016070")

x <- "0016070"
x <- "F14Z01Z"

x <- checks("5A02210")
x <- checks("0016070")

get_pin("tables_rows") |>
  vctrs::vec_slice(.data$system == substr(x$input, 1, 2)) |>
  dplyr::select(code_2, name_3:rows)

stringfish::sf_nchar("0016070")
stringfish::sf_substr()
nchar("0016070")

x <- x |>
  .section() |>
  .system() |>
  .operation() |>
  .part() |>
  .approach() |>
  .device() |>
  .qualifier()

pcs("0LQV3ZZ") |> data.table::as.data.table()

checks("F14Z01Z") |> .def_op()

vctrs::vec_rbind(x$definitions,
                 definitions(section = stringfish::sf_substr(x$input, 1, 1),
                             axis = "5",
                             col = "value",
                             search = substr(x$input, 5, 5),
                             # col = "label",
                             # search = delister(x$head[5, 4])
                             display = TRUE))

definitions(section = substr(x$input, 1, 1),
            axis = "3",
            col = "value",
            search = substr(x$input, 3, 3),
            # col = "label",
            # search = delister(x$head[5, 4])
            display = TRUE) |>
  # tidytable::as_tidytable()
  data.table::as.data.table()
