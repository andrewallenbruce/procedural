# ICD-10-PCS Devices

ICD-10-PCS Devices

## Usage

``` r
devices(
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

a [tibble](https://tibble.tidyverse.org/reference/tibble-package.html)

## Examples

``` r
devices()
#> Error in get_pin("devices"): could not find function "get_pin"
```
