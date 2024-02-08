library(janitor)
library(tidyverse)
library(qs)
`%nin%` <- function(x, table) match(x, table, nomatch = 0L) == 0L

ind <- pins::pin_read(procedural:::mount_board(), "source_index") |>
  slice(4:n()) |>
  select(-level1)

idx_letter <- ind |>
  filter(level2 == "letter", level3 == "title") |>
  select(elemid, letter = value)

ind <- left_join(ind, idx_letter) |>
  fill(letter) |>
  filter(!is.na(level3), level3 != "title") |>
  select(-level2)

idx_mainTerm <- ind |>
  count(level4)
filter(level3 == "mainTerm", level4 == "title") |>
  select(elemid, mainTerm = value)

ind <- left_join(ind, idx_mainTerm) |>
  fill(mainTerm) |>
  filter(!is.na(level4), level4 != "title") |>
  select(-level3) |>
  mutate(mainID = consecutive_id(mainTerm))

idx_lvl <- ind |>
  filter(!is.na(attr)) |>
  mutate(lid = paste0("L", value),
         llid = paste0(lid, "-", elemid)) |>
  select(elemid, llid, mainID)

ind <- left_join(ind, idx_lvl) |>
  group_by(mainID) |>
  fill(llid) |>
  ungroup() |>
  filter(is.na(attr), !is.na(value)) |>
  select(-attr)

#------------- Split - LVL 0
lvl_0 <- ind |>
  filter(is.na(llid)) |>
  remove_empty()

# Remove from `ind`, i.e.:
# ind |> filter(elemid %nin% elemid0) |> print(n = 100)
elemid0 <- lvl_0 |> pull(elemid) |> unique()

idx_v0 <- lvl_0 |>
  filter(is.na(level5)) |>
  mutate(val_0 = value) |>
  unite("act_0", level4, level5, sep = ":", na.rm = TRUE) |>
  select(mainID, val_0)

lvl_0 <- left_join(lvl_0, idx_v0) |>
  mutate(x_0 = ifelse(!is.na(level5), value, level5),
         act_0 = ifelse(!is.na(level5), paste0(level4, ":", level5), level5),
         act_0 = ifelse(is.na(level5), level4, act_0),
         x_0 = lead(x_0),
         act_0 = ifelse(!is.na(x_0), lead(act_0), act_0)) |>
  filter(is.na(level5)) |>
  select(elemid, letter, mainTerm, mainID, lid, act_0, val_0, x_0)

lvl_0 <- lvl_0 |>
  mutate(x_0 = ifelse((is.na(x_0) & elem %in% c("code", "codes", "tab")), val_0, x_0),
         val_0 = ifelse(elem %in% c("code", "codes", "tab"), NA_character_, val_0)) |>
  select(-elem)

lvl_0 |>
  print(n = 100)

##----- Remove from `ind`, i.e.:
ind <- ind |> filter(elemid %nin% elemid0)

#------------- Split - LVL 1
lvl_1 <- ind |>
  separate_wider_delim(llid,
                       delim = "-",
                       names = c("lvl", "lid"),
                       cols_remove = TRUE) |>
  filter(lvl == "L1")

# Remove from `ind`, i.e.:
# ind |> filter(elemid %nin% elemid0) |> print(n = 100)
elemid1 <- lvl_1 |> pull(elemid) |> unique()

lvl_1 <- lvl_1 |>
  remove_empty() |>
  select(-level4) |>
  mutate(x_1 = ifelse(!is.na(level6), value, level6),
         act_1 = ifelse(!is.na(level6), paste0(level5, ":", level6), level5),
         x_1 = lead(x_1),
         act_1 = ifelse(!is.na(x_1), lead(act_1), act_1)) |>
  filter(is.na(level6)) |>
  select(-level6, -lvl) |>
  mutate(x_1 = ifelse(level5 %in% c("code", "codes", "tab"), value, x_1)) |>
  group_by(lid) |>
  fill(x_1, .direction = "up") |>
  ungroup() |>
  filter(level5 %nin% c("code", "codes", "tab")) |>
  select(elemid, letter, mainTerm, mainID, lid, act_1, val_1 = value, x_1)

lvl_1 |>
  print(n = 100)

#------------- Split - LVL 2
lvl_2 <- ind |>
  separate_wider_delim(llid,
                       delim = "-",
                       names = c("lvl", "lid"),
                       cols_remove = TRUE) |>
  filter(lvl == "L2")


lvl_2 <- lvl_2 |>
  remove_empty() |>
  select(-level4, -level5) |>
  mutate(x_2 = ifelse(level6 %in% c("code", "codes", "tab"), value, NA_character_),
         act_2 = ifelse(level6 %in% c("code", "codes", "tab"), level6, NA_character_),
         x_2 = lead(x_2),
         act_2 = ifelse(!is.na(x_2), lead(act_2), act_2)) |>
  filter(level6 %nin% c("code", "codes", "tab")) |>
  select(elemid, letter, mainTerm, mainID, lid, act_2, val_2 = value, x_2)

lvl_2 |>
  print(n = 100)

#------------- Split - LVL 3
lvl_3 <- ind |>
  separate_wider_delim(llid,
                       delim = "-",
                       names = c("lvl", "lid"),
                       cols_remove = TRUE) |>
  filter(lvl == "L3")


lvl_3 <- lvl_3 |>
  remove_empty() |>
  select(-c(level4:level6)) |>
  mutate(x_3 = ifelse(level7 %in% c("code", "codes", "tab"), value, NA_character_),
         act_3 = ifelse(level7 %in% c("code", "codes", "tab"), level7, NA_character_),
         x_3 = lead(x_3),
         act_3 = ifelse(!is.na(x_3), lead(act_3), act_3)) |>
  filter(level7 %nin% c("code", "codes", "tab")) |>
  select(elemid, letter, mainTerm, mainID, lid, act_3, val_3 = value, x_3)

lvl_23 <- lvl_3 |>
  select(elemid) |>
  bind_rows(lvl_2) |>
  distinct(elemid, .keep_all = TRUE) |>
  arrange(elemid)

left_join(lvl_23, lvl_3, by = join_by("elemid")) |>
  unite('letter', letter.x, letter.y, sep = "", na.rm = TRUE) |>
  unite('mainTerm', mainTerm.x, mainTerm.y, sep = "", na.rm = TRUE) |>
  unite('action', act_2, act_3, sep = "", na.rm = TRUE) |>
  unite('codes', x_2, x_3, sep = "", na.rm = TRUE) |>
  mutate(action = na_if(action, ""),
         codes = na_if(codes, "")) |>
  select(-contains(c(".x", ".y"))) |>
  select(elemid, letter, mainTerm, action, val_2, val_3, codes) |>
  # fill(val_2) |>
  print(n = 100)
















idx_lvl2 <- ind |>
  filter(is.na(level5)) |>
  count(level4)
select(elemid, lvl_2 = value, mainTermID)

left_join(ind, idx_lvl2) |>
  group_by(elem) |>
  fill(lvl_2) |>
  ungroup() |>
  print(n = 100)
count(level5) |>
  filter(!is.na(level4), level4 != "title") |>
  select(-level3)
