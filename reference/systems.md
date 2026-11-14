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
if (FALSE) {
systems()

systems("0")

systems("2")

systems("X")
}
```
