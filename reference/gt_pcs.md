# Return ICD-10-PCS Code as a `gt` Table

Return ICD-10-PCS Code as a `gt` Table

## Usage

``` r
gt_pcs(x)
```

## Arguments

- x:

  an object of class `pcs`.

## Value

a gt table

## Examples

``` r
pcs("0G9000Z") |> gt_pcs()
#> Error in get_pin("sections"): could not find function "get_pin"

gt_pcs(pcs("0016070"))
#> Error in get_pin("sections"): could not find function "get_pin"
```
