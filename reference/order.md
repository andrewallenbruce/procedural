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
if (FALSE) {
order(search = "00X")
order(search = "Olfactory", col = "description_code")
}
```
