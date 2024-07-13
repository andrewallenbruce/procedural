## code to prepare `nests` dataset goes here
set <- pins::pin_read(procedural::mount_board(), "tables_rows") |>
  dplyr::mutate(system = paste0(code_1, code_2), .before = name_3)

rows_ids <- dplyr::select(set, row, rowid, rows) |>
  dplyr::group_by(row) |>
  tidyr::nest(.key = "rows_ids") |>
  dplyr::ungroup()

set2 <- dplyr::select(set, name_1:row) |>
  dplyr::distinct() |>
  dplyr::left_join(rows_ids)

tables_ids <- dplyr::select(set2, table:rows_ids) |>
  dplyr::group_by(table) |>
  tidyr::nest(.key = "tables_ids") |>
  dplyr::ungroup()

set2 <- dplyr::select(set2, name_1:table) |>
  dplyr::distinct() |>
  dplyr::left_join(tables_ids)

systems_ids <- dplyr::select(set2, system:tables_ids) |>
  dplyr::group_by(system) |>
  tidyr::nest(.key = "systems_ids") |>
  dplyr::ungroup()

set2 <- dplyr::select(set2, name_1:system) |>
  dplyr::distinct() |>
  dplyr::left_join(systems_ids)

set2_dt <- dtplyr::lazy_dt(set2)
set2_DT <- data.table::as.data.table(set2)
set2_tt <- tidytable::as_tidytable(set2)
# Sections
section <- set |>
  dplyr::select(name = name_1,
                value = code_1,
                label = label_1) |>
  dplyr::distinct() |>
  dplyr::mutate(axis = "1", .before = 1)


# System
system <- set |>
  dplyr::select(section = code_1,
                system,
                name = name_2,
                value = code_2,
                label = label_2) |>
  dplyr::distinct() |>
  dplyr::mutate(axis = "2", .before = 3) |>
  dplyr::group_by(section) |>
  tidyr::nest(.key = "system") |>
  dplyr::ungroup()

# Operation
operation <- set |>
  dplyr::select(system = code_2,
                table,
                name = name_3,
                value = code_3,
                label = label_3) |>
  dplyr::distinct() |>
  dplyr::mutate(axis = "3", .before = 3) |>
  dplyr::group_by(system) |>
  tidyr::nest(.key = "operation") |>
  dplyr::ungroup()

# Part
part <- set |>
  dplyr::select(operation = code_3,
                row,
                name = name_4,
                value = code_4,
                label = label_4) |>
  dplyr::distinct() |>
  dplyr::mutate(axis = "4", .before = 3) |>
  dplyr::group_by(operation) |>
  tidyr::nest(.key = "part") |>
  dplyr::ungroup()

## ROWS BASE
ROWBASE <- set |>
  dplyr::select(part = code_4,
                row,
                rowid,
                rows) |>
  tidyr::unnest(rows)

# Approach
approach <- ROWBASE |>
  dplyr::filter(axis == "5") |>
  dplyr::distinct() |>
  dplyr::group_by(part, row, rowid) |>
  tidyr::nest(.key = "approach") |>
  dplyr::ungroup()

# Device
device <- ROWBASE |>
  dplyr::select(-part) |>
  dplyr::filter(axis == "6") |>
  dplyr::distinct() |>
  dplyr::group_by(row, rowid) |>
  tidyr::nest(.key = "device") |>
  dplyr::ungroup()

# Qualifier
qualifier <- ROWBASE |>
  dplyr::select(-part) |>
  dplyr::filter(axis == "7") |>
  dplyr::distinct() |>
  dplyr::group_by(row, rowid) |>
  tidyr::nest(.key = "qualifier") |>
  dplyr::ungroup()






##------------------------------------------------------
# Device
app <- set |>
  dplyr::select(part = code_4, rowid, rows) |>
  tidyr::unnest(rows) |>
  dplyr::filter(axis == "5") |>
  dplyr::distinct() |>
  dplyr::select(approach = code, rowid)

devi <- set |>
  dplyr::select(part = code_4, rowid, rows) |>
  tidyr::unnest(rows) |>
  dplyr::filter(axis == "6") |>
  dplyr::distinct() |>
  dplyr::select(rowid:label)

device <- dplyr::left_join(app, devi, relationship = "many-to-many") |>
  dplyr::distinct() |>
  dplyr::group_by(approach, rowid) |>
  tidyr::nest(.key = "device") |>
  dplyr::ungroup()

# Qualifier
dvce <- set |>
  dplyr::select(part = code_4, rowid, rows) |>
  tidyr::unnest(rows) |>
  dplyr::filter(axis == "6") |>
  dplyr::distinct() |>
  dplyr::select(device = code, rowid)

qual <- set |>
  dplyr::select(part = code_4, rowid, rows) |>
  tidyr::unnest(rows) |>
  dplyr::filter(axis == "7") |>
  dplyr::distinct() |>
  dplyr::select(rowid:label)

qualifier <- dplyr::left_join(dvce, qual, relationship = "many-to-many") |>
  dplyr::distinct() |>
  dplyr::group_by(device, rowid) |>
  tidyr::nest(.key = "qualifier") |>
  dplyr::ungroup()


board <- pins::board_folder(here::here("pkgdown/assets/pins-board"))

board |> pins::pin_write(section,
                         name = "nest_section",
                         description = "Nest Sections",
                         type = "qs")

board |> pins::pin_write(system,
                         name = "nest_system",
                         description = "Nest Systems",
                         type = "qs")

board |> pins::pin_write(operation,
                         name = "nest_operation",
                         description = "Nest Operations",
                         type = "qs")

board |> pins::pin_write(part,
                         name = "nest_part",
                         description = "Nest Body Parts",
                         type = "qs")

board |> pins::pin_write(approach,
                         name = "nest_approach",
                         description = "Nest Approaches",
                         type = "qs")

board |> pins::pin_write(device,
                         name = "nest_device",
                         description = "Nest Devices",
                         type = "qs")

board |> pins::pin_write(qualifier,
                         name = "nest_qualifier",
                         description = "Nest Qualifiers",
                         type = "qs")

board |> pins::write_board_manifest()
