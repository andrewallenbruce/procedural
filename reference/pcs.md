# Look up ICD-10-PCS Codes or Tables

Look up ICD-10-PCS Codes or Tables

## Usage

``` r
pcs(x = NULL)
```

## Arguments

- x:

  an alphanumeric character vector, can be 3 to 7 characters long.

## Value

a [tibble](https://tibble.tidyverse.org/reference/tibble-package.html)

## Examples

``` r

pcs("0G9")
#> Error in get_pin("sections"): could not find function "get_pin"

pcs("0G90")
#> Error in get_pin("sections"): could not find function "get_pin"

pcs("0G900")
#> Error in get_pin("sections"): could not find function "get_pin"

pcs("0G9000")
#> Error in get_pin("sections"): could not find function "get_pin"

pcs("0G9000Z")
#> Error in get_pin("sections"): could not find function "get_pin"
```
