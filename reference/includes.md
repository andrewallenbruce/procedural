# ICD-10-PCS Includes

ICD-10-PCS Includes

## Usage

``` r
includes(
  section = NULL,
  axis = NULL,
  col = c("label", "name", "includes"),
  search = NULL
)
```

## Arguments

- section:

  PCS section:

  - `"0"` (Medical and Surgical),

  - `"3"` (Administration)

  - `"F"` (Physical Rehabilitation and Diagnostic Audiology)

  - `"G"` (Mental Health)

  - `"X"` (New Technology)

- axis:

  PCS axis:

  - `"3"`

    - Operation (0:9, X)

    - Type (B, C, F, G, H)

  - `"4"`

    - Qualifier (G)

  - `"5"`

    - Approach (0:4, 7:9, X)

    - Type Qualifier (F)

- col:

  column to search: `"name"`, `"label"` (default), `"includes"`

- search:

  string to search for in `col`

## Value

a [tibble](https://tibble.tidyverse.org/reference/tibble-package.html)

## Examples

``` r
if (FALSE) {
includes(section = "0", axis = "3")
}
```
