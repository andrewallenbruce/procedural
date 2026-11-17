# ICD-10-PCS Sections

ICD-10-PCS Sections

## Usage

``` r
section(x = NULL)
```

## Arguments

- x:

  ICD-10-PCS section value, an alphanumeric code of length 1. If `NULL`
  (default), returns all 17 sections.

## Value

tibble

## Examples

``` r
section()
#> # A tibble: 17 × 4
#>      pos title   code  label                                                
#>    <int> <chr>   <chr> <chr>                                                
#>  1     1 Section 0     Medical and Surgical                                 
#>  2     1 Section 1     Obstetrics                                           
#>  3     1 Section 2     Placement                                            
#>  4     1 Section 3     Administration                                       
#>  5     1 Section 4     Measurement and Monitoring                           
#>  6     1 Section 5     Extracorporeal or Systemic Assistance and Performance
#>  7     1 Section 6     Extracorporeal or Systemic Therapies                 
#>  8     1 Section 7     Osteopathic                                          
#>  9     1 Section 8     Other Procedures                                     
#> 10     1 Section 9     Chiropractic                                         
#> 11     1 Section B     Imaging                                              
#> 12     1 Section C     Nuclear Medicine                                     
#> 13     1 Section D     Radiation Therapy                                    
#> 14     1 Section F     Physical Rehabilitation and Diagnostic Audiology     
#> 15     1 Section G     Mental Health                                        
#> 16     1 Section H     Substance Abuse Treatment                            
#> 17     1 Section X     New Technology                                       
```
