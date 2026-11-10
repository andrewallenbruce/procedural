# ICD-10-PCS Definitions

ICD-10-PCS Definitions

## Usage

``` r
definitions(
  section = NULL,
  axis = NULL,
  col = c("value", "label", "name", "definition", "explanation"),
  search = NULL,
  display = FALSE
)
```

## Arguments

- section:

  PCS section: 0:9, B, C, F, G, H, X

- axis:

  PCS axis: 3, 4, 5

- col:

  column to search: "name", "value" (default), "label" "definition",
  "explanation"

- search:

  string to search for in `col`

- display:

  output for display, e.g. in `ggplot` or `gt`: `TRUE` or `FALSE`
  (default)

## Value

a [tibble](https://tibble.tidyverse.org/reference/tibble-package.html)

## Examples

``` r
definitions(col = "label", search = "drain")
#> Error in get_pin("definitions"): could not find function "get_pin"

definitions(section = "0", axis = "5")
#> Error in get_pin("definitions"): could not find function "get_pin"

definitions(section = "B", col = "label", search = "fluoro")
#> Error in get_pin("definitions"): could not find function "get_pin"

definitions(section = "B", col = "label", search = "fluoro", display = TRUE)
#> Error in get_pin("definitions"): could not find function "get_pin"
```
