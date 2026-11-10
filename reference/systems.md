# ICD-10-PCS Body Systems

ICD-10-PCS Body Systems

## Usage

``` r
systems(x = NULL)
```

## Arguments

- x:

  ICD-10-PCS body systems character, an alphanumeric code of length 1.
  If `NULL` (default), returns all 114 systems.

## Value

a [tibble](https://tibble.tidyverse.org/reference/tibble-package.html)

## Examples

``` r
systems()
#> Error in get_pin("systems"): could not find function "get_pin"

systems("0")
#> Error in get_pin("systems"): could not find function "get_pin"

systems("2")
#> Error in get_pin("systems"): could not find function "get_pin"

systems("X")
#> Error in get_pin("systems"): could not find function "get_pin"
```
