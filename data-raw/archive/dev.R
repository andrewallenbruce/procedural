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


paste0("(", pat1, "|", pat2, ")")

x <- c('T1503', 'G0478', '81301', '69641', '0583F', '0779T', '0000V', 'D6964', 'B0123')

stringfish::sf_grepl(x, "(^\\d{4}[AFMTU0-9]$|^[A-CEGHJ-MP-V]\\d{4}$)")

northstar::search_descriptions("B0123")
northstar::is_valid_hcpcs(x)
#> [1]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE

x[which(northstar::is_valid_hcpcs(x))]
