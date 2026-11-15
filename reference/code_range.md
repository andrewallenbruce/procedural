# Return a range of ICD-10-PCS codes

Return a range of ICD-10-PCS codes

## Usage

``` r
code_range(start, end)
```

## Arguments

- start, end:

  `<chr>` Full 7-character ICD-10-PCS code.

## Value

a [tibble::tibble](https://tibble.tidyverse.org/reference/tibble.html)
containing the results

## Examples

``` r
code_range("0G9000Z", "0G9100Z")
#> Error in loadNamespace(x): there is no package called ‘pcs’
code_range("0G9000Z", "10D20ZZ")
#> Error in loadNamespace(x): there is no package called ‘pcs’
```
