# PCS Code Addenda

PCS Code Addenda

## Usage

``` r
definitions(section = NULL, axis = NULL, term = NULL)

includes(section = NULL, axis = NULL, term = NULL)

explanations(section = NULL, axis = NULL, term = NULL)
```

## Arguments

- section:

  `<chr>` PCS section

- axis:

  `<int>` PCS axis

- term:

  `<chr>` PCS term

## Value

a [tibble::tibble](https://tibble.tidyverse.org/reference/tibble.html)
containing the results

## Examples

``` r
definitions(term = "drain")
#> # A data frame: 2 × 6
#>   entry section  axis name      term     definition                             
#>   <int> <chr>   <int> <chr>     <chr>    <chr>                                  
#> 1    10 0           3 Operation Drainage Taking or letting out fluids and/or ga…
#> 2   518 1           3 Operation Drainage Taking or letting out fluids and/or ga…
definitions(section = "0", axis = 5)
#> # A data frame: 7 × 6
#>   entry section  axis name     term                                   definition
#>   <int> <chr>   <int> <chr>    <chr>                                  <chr>     
#> 1   361 0           5 Approach External                               Procedure…
#> 2   362 0           5 Approach Open                                   Cutting t…
#> 3   363 0           5 Approach Percutaneous                           Entry, by…
#> 4   364 0           5 Approach Percutaneous Endoscopic                Entry, by…
#> 5   365 0           5 Approach Via Natural or Artificial Opening      Entry of …
#> 6   366 0           5 Approach Via Natural or Artificial Opening End… Entry of …
#> 7   367 0           5 Approach Via Natural or Artificial Opening Wit… Entry of …
definitions(section = "B", term = "fluoro")
#> # A data frame: 1 × 6
#>   entry section  axis name  term        definition                              
#>   <int> <chr>   <int> <chr> <chr>       <chr>                                   
#> 1   603 B           3 Type  Fluoroscopy Single plane or bi-plane real time disp…


includes(term = "drain")
#> # A tibble: 2 × 6
#>   entry section  axis name      term            includes                        
#>   <int> <chr>   <int> <chr>     <chr>           <chr>                           
#> 1    10 0           3 Operation Drainage        Thoracentesis, incision and dra…
#> 2   397 0           6 Device    Drainage Device Cystostomy tube | Foley cathete…
includes(section = "0", axis = 6, term = "^art")
#> # A tibble: 3 × 6
#>   entry section  axis name   term                                       includes
#>   <int> <chr>   <int> <chr>  <chr>                                      <chr>   
#> 1   368 0           6 Device Articulating Spacer in Lower Joints        Articul…
#> 2   369 0           6 Device Artificial Sphincter in Gastrointestinal … Artific…
#> 3   370 0           6 Device Artificial Sphincter in Urinary System     AMS 800…
includes(section = "3", term = "pro")
#> # A tibble: 3 × 6
#>   entry section  axis name      term                                    includes
#>   <int> <chr>   <int> <chr>     <chr>                                   <chr>   
#> 1   550 3           6 Substance 4-Factor Prothrombin Complex Concentra… Kcentra 
#> 2   557 3           6 Substance Hematopoietic Stem/Progenitor Cells, G… OTL-101 
#> 3   568 3           6 Substance Recombinant Bone Morphogenetic Protein  Bone mo…


explanations(term = "drain")
#> # A data frame: 1 × 6
#>   entry section  axis name      term     explanation                            
#>   <int> <chr>   <int> <chr>     <chr>    <chr>                                  
#> 1    10 0           3 Operation Drainage The qualifier DIAGNOSTIC is used to id…
explanations("X", 3, "destruction")
#> # A data frame: 1 × 6
#>   entry section  axis name      term        explanation                         
#>   <int> <chr>   <int> <chr>     <chr>       <chr>                               
#> 1   814 X           3 Operation Destruction None of the body part is physically…

```
