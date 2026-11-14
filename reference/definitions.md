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

  `<lgl>` Return complete entries; default is TRUE

## Value

a [tibble::tibble](https://tibble.tidyverse.org/reference/tibble.html)
containing the results

## Examples

``` r
definitions(term = "drinnn")
#> Error: term = "drinnn" returned 0 rows
definitions(term = "drain")
#> # A tibble: 25 × 6
#>    entry section  axis name      field       value                              
#>    <int> <chr>   <int> <chr>     <chr>       <chr>                              
#>  1     9 0           3 Operation value       Division                           
#>  2     9 0           3 Operation definition  Cutting into a body part, without …
#>  3     9 0           3 Operation explanation All or a portion of the body part …
#>  4     9 0           3 Operation includes    Spinal cordotomy, osteotomy        
#>  5    10 0           3 Operation value       Drainage                           
#>  6    10 0           3 Operation definition  Taking or letting out fluids and/o…
#>  7    10 0           3 Operation explanation The qualifier DIAGNOSTIC is used t…
#>  8    10 0           3 Operation includes    Thoracentesis, incision and draina…
#>  9    22 0           3 Operation value       Removal                            
#> 10    22 0           3 Operation definition  Taking out or off a device from a …
#> # ℹ 15 more rows
definitions(section = "0", axis = 5)
#> # A tibble: 14 × 6
#>    entry section  axis name     field      value                                
#>    <int> <chr>   <int> <chr>    <chr>      <chr>                                
#>  1   361 0           5 Approach value      External                             
#>  2   361 0           5 Approach definition Procedures performed directly on the…
#>  3   362 0           5 Approach value      Open                                 
#>  4   362 0           5 Approach definition Cutting through the skin or mucous m…
#>  5   363 0           5 Approach value      Percutaneous                         
#>  6   363 0           5 Approach definition Entry, by puncture or minor incision…
#>  7   364 0           5 Approach value      Percutaneous Endoscopic              
#>  8   364 0           5 Approach definition Entry, by puncture or minor incision…
#>  9   365 0           5 Approach value      Via Natural or Artificial Opening    
#> 10   365 0           5 Approach definition Entry of instrumentation through a n…
#> 11   366 0           5 Approach value      Via Natural or Artificial Opening En…
#> 12   366 0           5 Approach definition Entry of instrumentation through a n…
#> 13   367 0           5 Approach value      Via Natural or Artificial Opening Wi…
#> 14   367 0           5 Approach definition Entry of instrumentation through a n…
definitions(section = "B", term = "fluoro")
#> # A tibble: 2 × 6
#>   entry section  axis name  field      value                                    
#>   <int> <chr>   <int> <chr> <chr>      <chr>                                    
#> 1   603 B           3 Type  value      Fluoroscopy                              
#> 2   603 B           3 Type  definition Single plane or bi-plane real time displ…
definitions()
#> # A tibble: 3,188 × 6
#>    entry section  axis name      field       value                              
#>    <int> <chr>   <int> <chr>     <chr>       <chr>                              
#>  1     1 0           3 Operation value       Alteration                         
#>  2     1 0           3 Operation definition  Modifying the anatomic structure o…
#>  3     1 0           3 Operation explanation Principal purpose is to improve ap…
#>  4     1 0           3 Operation includes    Face lift, breast augmentation     
#>  5     2 0           3 Operation value       Bypass                             
#>  6     2 0           3 Operation definition  Altering the route of passage of t…
#>  7     2 0           3 Operation explanation Rerouting contents of a body part …
#>  8     2 0           3 Operation includes    Coronary artery bypass, colostomy …
#>  9     3 0           3 Operation value       Change                             
#> 10     3 0           3 Operation definition  Taking out or off a device from a …
#> # ℹ 3,178 more rows
```
