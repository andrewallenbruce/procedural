# Validate Section Values

The 17 valid PCS Section values are "B-D", "F-H", "X", and "0-9".

## Usage

``` r
is_section_value(x)
```

## Arguments

- x:

  `<chr>` string

## Value

`<lgl>` `TRUE` if valid, otherwise `FALSE`

## See also

Other PCS validators:
[`is_section_code()`](https://andrewallenbruce.github.io/procedural/reference/is_section_code.md),
[`is_system_value()`](https://andrewallenbruce.github.io/procedural/reference/is_system_value.md)

## Examples

``` r
x <- c("0", "3", "K")

is_section_value(x)
#> [1]  TRUE  TRUE FALSE

x[which(is_section_value(x))]
#> [1] "0" "3"

try(is_section_value("XX"))
#> Error in is_section_value("XX") : 
#>   `x` must be 1 character long.
```
