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
if (FALSE) {
index(search = "Abdominohysterectomy")
index(search = "Attain Ability")
index(search = "radi*")
}
```
