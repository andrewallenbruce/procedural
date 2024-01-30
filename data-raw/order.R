library(janitor)
library(tidyverse)
library(qs)

ord <- pins::pin_read(mount_board(), "source_order")

tbl <- ord |>
  dplyr::filter(valid == 0) |>
  dplyr::mutate(start = order,
                end = dplyr::lead(start) - 1,
                end = dplyr::case_when(start == max(start) ~ {
                  dplyr::slice_tail(ord) |>
                    dplyr::pull(order)},
                  .default = end)) |>
  dplyr::select(
    order,
    table = code,
    description = description_long,
    start,
    end)

ord <- ord |>
  dplyr::left_join(tbl) |>
  dplyr::select(order,
                table,
                code,
                valid,
                description_table = description,
                description_code = description_long) |>
  tidyr::fill(table, description_table) |>
  dplyr::filter(valid == 1) |>
  dplyr::select(-valid) |>
  dplyr::mutate(order = row_number()) |>
  dplyr::mutate(row = substr(code, 1, 4), .before = code)


# ord |> filter(code == str_subset(code, "027004"))

# ord |>
#   filter(grepl("Dilation", description_code)) |>
#   filter(grepl("0270", code)) |>
#   filter(table == "027") |>
#   count(row)

# ord |>
#   select(table, row, code) |>
#   count(table, sort = TRUE) |>
#   filter(table == "027")
#   filter(n > 100)

# |>
#   dplyr::distinct()
#   tidyr::nest(.by = c(table, description), .key = "codes")

# ord |>
#   tidyr::separate_wider_position(table, c(section = 1, system = 1, operation = 1), cols_remove = FALSE) |>
#   tidyr::unite('system', section:system, remove = FALSE, sep = "") |>
#   dplyr::select(section, system, table, description, codes)

########________________________________________
board <- pins::board_folder(here::here("pkgdown/assets/pins-board"))

board |> pins::pin_write(ord,
                         name = "tables_order",
                         description = "ICD-10-PCS Order File 2024",
                         type = "qs")

board |> pins::write_board_manifest()

