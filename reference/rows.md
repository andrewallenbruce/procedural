# ICD-10-PCS Rows

ICD-10-PCS Rows

## Usage

``` r
rows(x = NULL)
```

## Arguments

- x:

  3 to 4-character string representing an ICD-10-PCS row within a table.
  If `NULL` (default), returns all ~ 29k rows.

## Value

a [tibble](https://tibble.tidyverse.org/reference/tibble-package.html)

## Examples

``` r
if (FALSE) {
rows("00X")

rows("00XF")
}
```
