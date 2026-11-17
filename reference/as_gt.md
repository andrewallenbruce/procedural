# Return ICD-10-PCS Code as a `gt` Table

Return ICD-10-PCS Code as a `gt` Table

## Usage

``` r
as_gt(x)

as_gt2(x)
```

## Arguments

- x:

  an object of class `pcs`.

## Value

a gt table

## Examples

``` r
if (FALSE) {
pcs("0G9000Z") |> as_gt()
as_gt(pcs("0016070"))
}
if (FALSE) {
pcs("0G9000Z") |> as_gt2()
as_gt2(pcs("0016070"))
}
```
