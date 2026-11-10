# ICD-10-PCS Sections

ICD-10-PCS Sections

## Usage

``` r
sections(x = NULL)
```

## Arguments

- x:

  ICD-10-PCS section value, an alphanumeric code of length 1. If `NULL`
  (default), returns all 17 sections.

## Value

a [tibble](https://tibble.tidyverse.org/reference/tibble-package.html)

## Examples

``` r
sections()
#> Error in get_pin("sections"): could not find function "get_pin"

sections("0")
#> Error in get_pin("sections"): could not find function "get_pin"

sections("2")
#> Error in get_pin("sections"): could not find function "get_pin"

sections("X")
#> Error in get_pin("sections"): could not find function "get_pin"
```
