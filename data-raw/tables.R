## code to prepare `tables` dataset goes here
library(icd10us)
library(tidyverse)

tables <- icd10pcs |>
  dplyr::filter(valid_billing_code == 0) |>
  dplyr::mutate(start = order_number,
                end = dplyr::lead(start) - 1,
                end = dplyr::case_when(start == max(start) ~ {
                  dplyr::slice_tail(icd10pcs) |>
                    dplyr::pull(order_number)},
                  .default = end)) |>
  dplyr::select(
    rowid = order_number,
    start,
    end,
    table = icd10pcs_code,
    description = icd10pcs_long_description)

pcs_by_table <- icd10pcs |>
  dplyr::select(
    rowid = order_number,
    code = icd10pcs_code,
    valid_billing_code,
    label = icd10pcs_long_description) |>
  dplyr::left_join(tables) |>
  tidyr::fill(table, description, start, end) |>
  dplyr::filter(valid_billing_code == 1) |>
  dplyr::select(code,
                label,
                table,
                description) |>
  dplyr::mutate(medsurg = stringr::str_detect(table, "^0"),
                description = dplyr::if_else(medsurg == TRUE,
                                             paste0("Medical and Surgical, ", description), description),
                medsurg = NULL)

pcs_by_table <- pcs_by_table |>
  tidyr::nest(codes = c(code, label)) |>
  tidyr::separate_wider_position(table, c(section = 1, system = 1, operation = 1), cols_remove = FALSE) |>
  tidyr::unite('system', section:system, remove = FALSE, sep = "") |>
  dplyr::select(section, system, table, description, codes)

board <- pins::board_folder(here::here("pkgdown/assets/pins-board"))

board |> pins::pin_write(pcs_by_table,
                         name = "pcs_by_table_v2",
                         description = "ICD-10-PCS 2024 Tables and Codes",
                         type = "qs")

board |> pins::write_board_manifest()
