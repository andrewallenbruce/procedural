# ICD-10-PCS Devices

ICD-10-PCS Devices

## Usage

``` r
device(
  system = NULL,
  operation = NULL,
  device = NULL,
  col = c("device_name", "section", "system", "operation", "device", "includes"),
  search = NULL
)
```

## Arguments

- system:

  PCS system character.

- operation:

  PCS operation character.

- device:

  PCS device character.

- col:

  column to search: "device_name" (default), "section", "system",
  "operation", "device", "includes"

- search:

  string to search for in `col`

## Value

tibble

## Examples

``` r
if (FALSE) {
device()
}
```
