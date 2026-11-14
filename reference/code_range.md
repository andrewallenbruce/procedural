# Return a range of ICD-10-PCS codes

Return a range of ICD-10-PCS codes

## Usage

``` r
code_range(start, end)
```

## Arguments

- start:

  7-character ICD-10-PCS code.

- end:

  7-character ICD-10-PCS code.

## Value

a [tibble](https://tibble.tidyverse.org/reference/tibble-package.html)

## Examples

``` r
if (FALSE) {
code_range("0G9000Z", "0G9100Z")
code_range("0G9000Z", "10D20ZZ")
}
```
