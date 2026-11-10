# ICD-10-PCS Order File

ICD-10-PCS Order File

## Usage

``` r
order(
  search = NULL,
  col = c("code", "table", "row", "description_code", "description_table", "order")
)
```

## Arguments

- search:

  string to search for in `col`

- col:

  column to search: "code" (default), "table", "row",
  "description_code", "description_table", "order"

## Value

a [tibble](https://tibble.tidyverse.org/reference/tibble-package.html)

## Examples

``` r
order(search = "00X")
#> Error in get_pin("tables_order"): could not find function "get_pin"

order(search = "Olfactory", col = "description_code")
#> Error in get_pin("tables_order"): could not find function "get_pin"
```
