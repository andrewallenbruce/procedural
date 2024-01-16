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
                code,
                valid,
                description_long,
                table,
                description) |>
  tidyr::fill(table, description) |>
  dplyr::filter(valid == 1) |>
  dplyr::select(-valid) |>
  dplyr::mutate(order = row_number()) |>
  tidyr::nest(.by = c(table, description), .key = "codes")

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

