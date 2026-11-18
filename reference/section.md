# ICD-10-PCS Axes

ICD-10-PCS Axes

## Usage

``` r
section(x = NULL)

system(x = NULL)

table(x = NULL)
```

## Arguments

- x:

  alphanumeric code; default is`NULL`

## Value

tibble

## Examples

``` r
section()
#> # A tibble: 17 × 5
#>    table   pos title   code  label                                              
#>    <int> <int> <chr>   <chr> <chr>                                              
#>  1     1     1 Section 0     Medical and Surgical                               
#>  2   607     1 Section 1     Obstetrics                                         
#>  3   619     1 Section 2     Placement                                          
#>  4   629     1 Section 3     Administration                                     
#>  5   633     1 Section 4     Measurement and Monitoring                         
#>  6   636     1 Section 5     Extracorporeal or Systemic Assistance and Performa…
#>  7   639     1 Section 6     Extracorporeal or Systemic Therapies               
#>  8   650     1 Section 7     Osteopathic                                        
#>  9   651     1 Section 8     Other Procedures                                   
#> 10   653     1 Section 9     Chiropractic                                       
#> 11   654     1 Section B     Imaging                                            
#> 12   752     1 Section C     Nuclear Medicine                                   
#> 13   791     1 Section D     Radiation Therapy                                  
#> 14   848     1 Section F     Physical Rehabilitation and Diagnostic Audiology   
#> 15   862     1 Section G     Mental Health                                      
#> 16   874     1 Section H     Substance Abuse Treatment                          
#> 17   881     1 Section X     New Technology                                     

system()
#> # A tibble: 84 × 5
#>    table   pos title       code  label                                    
#>    <int> <int> <chr>       <chr> <chr>                                    
#>  1     1     1 Section     0     Medical and Surgical                     
#>  2     1     2 Body System 0     Central Nervous System and Cranial Nerves
#>  3    23     2 Body System 1     Peripheral Nervous System                
#>  4    40     2 Body System 2     Heart and Great Vessels                  
#>  5    62     2 Body System 3     Upper Arteries                           
#>  6    80     2 Body System 4     Lower Arteries                           
#>  7    98     2 Body System 5     Upper Veins                              
#>  8   117     2 Body System 6     Lower Veins                              
#>  9   136     2 Body System 7     Lymphatic and Hemic Systems              
#> 10   155     2 Body System 8     Eye                                      
#> # ℹ 74 more rows

table()
#> # A tibble: 2,754 × 5
#>    table   pos title       code  label                                    
#>    <int> <int> <chr>       <chr> <chr>                                    
#>  1     1     1 Section     0     Medical and Surgical                     
#>  2     1     2 Body System 0     Central Nervous System and Cranial Nerves
#>  3     1     3 Operation   1     Bypass                                   
#>  4     2     1 Section     0     Medical and Surgical                     
#>  5     2     2 Body System 0     Central Nervous System and Cranial Nerves
#>  6     2     3 Operation   2     Change                                   
#>  7     3     1 Section     0     Medical and Surgical                     
#>  8     3     2 Body System 0     Central Nervous System and Cranial Nerves
#>  9     3     3 Operation   5     Destruction                              
#> 10     4     1 Section     0     Medical and Surgical                     
#> # ℹ 2,744 more rows
```
