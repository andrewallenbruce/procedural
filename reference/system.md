# ICD-10-PCS Body Systems

ICD-10-PCS Body Systems

## Usage

``` r
system(x = NULL)
```

## Arguments

- x:

  ICD-10-PCS body systems character, an alphanumeric code of length 1.
  If `NULL` (default), returns all 114 systems.

## Value

tibble

## Examples

``` r
system()
#> # A tibble: 84 × 4
#>      pos title       code  label                                    
#>    <int> <chr>       <chr> <chr>                                    
#>  1     1 Section     0     Medical and Surgical                     
#>  2     2 Body System 0     Central Nervous System and Cranial Nerves
#>  3     2 Body System 1     Peripheral Nervous System                
#>  4     2 Body System 2     Heart and Great Vessels                  
#>  5     2 Body System 3     Upper Arteries                           
#>  6     2 Body System 4     Lower Arteries                           
#>  7     2 Body System 5     Upper Veins                              
#>  8     2 Body System 6     Lower Veins                              
#>  9     2 Body System 7     Lymphatic and Hemic Systems              
#> 10     2 Body System 8     Eye                                      
#> # ℹ 74 more rows
```
