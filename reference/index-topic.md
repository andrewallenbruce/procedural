# ICD-10-PCS Index

ICD-10-PCS Index

## Usage

``` r
index(search = NULL, col = c("term", "index", "verb", "value", "code"))
```

## Arguments

- search:

  string to search for in `col`

- col:

  column to search: "term" (default), "index", "type", "value", "code"

## Value

a [tibble](https://tibble.tidyverse.org/reference/tibble-package.html)

## Examples

``` r
index(search = "Abdominohysterectomy")
#> Error in get_pin("index_v2"): could not find function "get_pin"

index(search = "Attain Ability")
#> Error in get_pin("index_v2"): could not find function "get_pin"

index(search = "radi*")
#> Error in get_pin("index_v2"): could not find function "get_pin"
```
