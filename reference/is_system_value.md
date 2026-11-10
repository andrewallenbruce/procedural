# Validate System Values

The 34 valid PCS System values are "A-H", "J-N", "P-Z", and "0-9".

## Usage

``` r
is_system_value(system_value)
```

## Arguments

- system_value:

  `<chr>` string

## Value

`<lgl>` `TRUE` if valid, otherwise `FALSE`

## See also

Other PCS value validators:
[`is_section_value()`](https://andrewallenbruce.github.io/procedural/reference/is_section_value.md)

## Examples

``` r
x <- c(LETTERS, 0:9)

is_system_value(x)
#>  [1]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE  TRUE  TRUE
#> [13]  TRUE  TRUE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
#> [25]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE

x[which(is_system_value(x))]
#>  [1] "A" "B" "C" "D" "E" "F" "G" "H" "J" "K" "L" "M" "N" "P" "Q" "R" "S" "T" "U"
#> [20] "V" "W" "X" "Y" "Z" "0" "1" "2" "3" "4" "5" "6" "7" "8" "9"

try(is_system_value("XX"))
#> Error in is_system_value("XX") : 
#>   `system_value` must be 1 character long.
```
