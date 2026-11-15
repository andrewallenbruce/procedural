# ICD-10-PCS Definitions

ICD-10-PCS Definitions

## Usage

``` r
definitions(section = NULL, axis = NULL, term = NULL, complete = TRUE)
```

## Arguments

- section:

  `<chr>` PCS section; one of `0:9, B, C, F, G, H, X`

- axis:

  `<int>` PCS axis; one of `3, 4, 5, 6`

  - 3: Operation

  - 3: Type

  - 4: Body Part

  - 4: Qualifier

  - 5: Approach

  - 5: Type Qualifier

  - 6: Substance

  - 6: Device

  - 6: Device / Substance / Technology

- term:

  `<chr>` term to search for

- complete:

  `<lgl>` Return complete entries; default is `TRUE`

## Value

a [tibble::tibble](https://tibble.tidyverse.org/reference/tibble.html)
containing the results

## Examples

``` r
definitions(term = "drinnn")
#> Error in loadNamespace(x): there is no package called ‘pcs’
definitions(term = "drain")
#> Error in loadNamespace(x): there is no package called ‘pcs’
definitions(section = "0", axis = 5)
#> Error in loadNamespace(x): there is no package called ‘pcs’
definitions(section = "B", term = "fluoro")
#> Error in loadNamespace(x): there is no package called ‘pcs’
definitions()
#> Error in loadNamespace(x): there is no package called ‘pcs’
```
