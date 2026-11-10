# Validate Full PCS Codes by Section

Validate Full PCS Codes by Section

## Usage

``` r
is_section_code(section_value = substr(pcs_code, 1L, 1L)[1], pcs_code)
```

## Arguments

- section_value:

  `<chr>` string

- pcs_code:

  `<chr>` string

## Value

`<lgl>` `TRUE` if valid, otherwise `FALSE`

## Examples

``` r
is_section_code(section_value = "0", pcs_code = "01UB3KZ")
#> [1] TRUE

x <- c("00DN0ZZ", "01UB3KZ", "0BBBFBB")

is_section_code(pcs_code = x)
#> [1] TRUE TRUE TRUE

x[which(is_section_code(pcs_code = x))]
#> [1] "00DN0ZZ" "01UB3KZ" "0BBBFBB"

try(is_section_code(pcs_code = "01UB3K"))
#> Error in is_section_code(pcs_code = "01UB3K") : 
#>   `pcs_code` must be 7 characters long.
```
