# x <- procedural:::process_order()
# x <- process_index(xml = TRUE)       # 145.05 sec / ~2.42 min
# x <- process_definitions(xml = TRUE) #   4.28 sec
# x <- process_tables(xml = TRUE)      # 366.71 sec / ~6.11 min

nanoparquet::write_parquet(
  x,
  file = fs::path_abs(fs::path(
    "inst/extdata",
    "icd10pcs_tables_2027",
    ext = "parquet"
  )),
  schema = nanoparquet::infer_parquet_schema(x)
)

nanoparquet::read_parquet(pkg_files(ext = "parquet"))

purrr::map(
  pkg_files(ext = "parquet"),
  nanoparquet::read_parquet_info
) |>
  collapse::rowbind() |>
  str()
