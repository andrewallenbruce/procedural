# Return ICD-10-PCS Code as a `gt` Table

Return ICD-10-PCS Code as a `gt` Table

## Usage

``` r
gt_pcs2(x)
```

## Arguments

- x:

  an object of class `pcs`.

## Value

description

## Examples

``` r
pcs("0G9000Z") |> gt_pcs2()
#> Error in get_pin("sections"): could not find function "get_pin"

gt_pcs2(pcs("0016070"))
#> Error in get_pin("sections"): could not find function "get_pin"
```
