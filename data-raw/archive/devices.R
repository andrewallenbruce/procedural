library(tidyverse)
library(janitor)
`%nin%` <- function(x, table) match(x, table, nomatch = 0L) == 0L

devices <- pins::pin_read(mount_board(), "source_definitions") |>
  select(-level1) |>
  mutate(rowid = row_number(), .before = 1) |>
  filter(level2 == "deviceAggregation") |>
  select(-level2, -level3, -level5) |>
  slice(3:400) |>
  filter(!is.na(level4)) |>
  mutate(elem = if_else(!is.na(attr), attr, elem),
         rowid = row_number()) |>
  select(-level4, -attr, -elemid) |>
  pivot_wider(names_from = elem,
              values_from = value) |>
  mutate(operation = lead(operation),
         bodySys = lead(bodySys, 2),
         parent = lead(parent, 3),
         value = lead(value, 4)) |>
  filter(!is.na(bodySys)) |>
  fill(parent, value, .direction = ("up")) |>
  fill(device, operation) |>
  select(device, operation, system = bodySys, parent, value)

devices |> print(n = 100)

##----------------------------------------
board <- pins::board_folder(here::here("pkgdown/assets/pins-board"))

board |> pins::pin_write(devices,
                         name = "devices",
                         description = "ICD-10-PCS 2024 Devices",
                         type = "qs")

board |> pins::write_board_manifest()
