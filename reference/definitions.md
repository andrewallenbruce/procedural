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
try(definitions(term = "drinnn"))
#> Error in definitions(term = "drinnn") : 
#>   term = "drinnn" returned 0 rows
definitions(term = "drain")
#> # A tibble: 8 × 7
#>   entry section  axis name      term            field       value               
#>   <int> <chr>   <int> <chr>     <chr>           <chr>       <chr>               
#> 1    10 0           3 Operation Drainage        Definition  Taking or letting o…
#> 2    10 0           3 Operation Drainage        Explanation The qualifier DIAGN…
#> 3    10 0           3 Operation Drainage        Includes    Thoracentesis, inci…
#> 4   397 0           6 Device    Drainage Device Includes    Cystostomy tube     
#> 5   397 0           6 Device    Drainage Device Includes    Foley catheter      
#> 6   397 0           6 Device    Drainage Device Includes    Percutaneous nephro…
#> 7   397 0           6 Device    Drainage Device Includes    Thoracostomy tube   
#> 8   518 1           3 Operation Drainage        Definition  Taking or letting o…
definitions(section = "0", axis = 5)
#> # A tibble: 7 × 7
#>   entry section  axis name     term                                  field value
#>   <int> <chr>   <int> <chr>    <chr>                                 <chr> <chr>
#> 1   361 0           5 Approach External                              Defi… Proc…
#> 2   362 0           5 Approach Open                                  Defi… Cutt…
#> 3   363 0           5 Approach Percutaneous                          Defi… Entr…
#> 4   364 0           5 Approach Percutaneous Endoscopic               Defi… Entr…
#> 5   365 0           5 Approach Via Natural or Artificial Opening     Defi… Entr…
#> 6   366 0           5 Approach Via Natural or Artificial Opening En… Defi… Entr…
#> 7   367 0           5 Approach Via Natural or Artificial Opening Wi… Defi… Entr…
definitions(section = "B", term = "fluoro")
#> # A tibble: 1 × 7
#>   entry section  axis name  term        field      value                        
#>   <int> <chr>   <int> <chr> <chr>       <chr>      <chr>                        
#> 1   603 B           3 Type  Fluoroscopy Definition Single plane or bi-plane rea…
definitions()
#> # A tibble: 2,212 × 7
#>    entry section  axis name      term       field       value                   
#>    <int> <chr>   <int> <chr>     <chr>      <chr>       <chr>                   
#>  1     1 0           3 Operation Alteration Definition  Modifying the anatomic …
#>  2     1 0           3 Operation Alteration Explanation Principal purpose is to…
#>  3     1 0           3 Operation Alteration Includes    Face lift, breast augme…
#>  4     2 0           3 Operation Bypass     Definition  Altering the route of p…
#>  5     2 0           3 Operation Bypass     Explanation Rerouting contents of a…
#>  6     2 0           3 Operation Bypass     Includes    Coronary artery bypass,…
#>  7     3 0           3 Operation Change     Definition  Taking out or off a dev…
#>  8     3 0           3 Operation Change     Explanation All CHANGE procedures a…
#>  9     3 0           3 Operation Change     Includes    Urinary catheter change…
#> 10     4 0           3 Operation Control    Definition  Stopping, or attempting…
#> # ℹ 2,202 more rows
```
