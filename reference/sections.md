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
if (FALSE) {
sections()

sections("0")

sections("2")

sections("X")
}
```
