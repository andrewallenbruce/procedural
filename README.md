
<!-- README.md is generated from README.Rmd. Please edit that file -->

# procedural

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![Codecov test
coverage](https://codecov.io/gh/andrewallenbruce/procedural/branch/main/graph/badge.svg)](https://app.codecov.io/gh/andrewallenbruce/procedural?branch=main)
[![R-CMD-check](https://github.com/andrewallenbruce/procedural/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/andrewallenbruce/procedural/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

## :package: Installation

You can install **`procedural`** from [GitHub](https://github.com/)
with:

``` r
# install.packages("pak")
pak::pak("andrewallenbruce/procedural")
```

## :beginner: Usage

``` r
library(procedural)
```

## Sections

``` r
sections()
```

    #> # A tibble: 17 × 4
    #>     axis name    code  label                                                
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

## Systems

``` r
systems()
```

    #> # A tibble: 114 × 4
    #>     axis name        code  label                                    
    #>    <int> <chr>       <chr> <chr>                                    
    #>  1     2 Body System 00    Central Nervous System and Cranial Nerves
    #>  2     2 Body System 01    Peripheral Nervous System                
    #>  3     2 Body System 02    Heart and Great Vessels                  
    #>  4     2 Body System 03    Upper Arteries                           
    #>  5     2 Body System 04    Lower Arteries                           
    #>  6     2 Body System 05    Upper Veins                              
    #>  7     2 Body System 06    Lower Veins                              
    #>  8     2 Body System 07    Lymphatic and Hemic Systems              
    #>  9     2 Body System 08    Eye                                      
    #> 10     2 Body System 09    Ear, Nose, Sinus                         
    #> # ℹ 104 more rows

## Tables

``` r
tables("00X")
```

    #> # A tibble: 1 × 5
    #>   section system table description                                    codes     
    #>   <chr>   <chr>  <chr> <chr>                                          <list>    
    #> 1 0       00     00X   Medical and Surgical, Central Nervous System … <spc_tbl_>

## Definitions

``` r
definitions()
```

    #> # A tibble: 917 × 8
    #>    code  section           axis  axis_name label definition explanation includes
    #>    <chr> <chr>             <chr> <chr>     <chr> <chr>      <chr>       <chr>   
    #>  1 0     Medical and Surg… 3     Operation Alte… Modifying… Principal … Face li…
    #>  2 0     Medical and Surg… 3     Operation Bypa… Altering … Rerouting … Coronar…
    #>  3 0     Medical and Surg… 3     Operation Chan… Taking ou… All CHANGE… Urinary…
    #>  4 0     Medical and Surg… 3     Operation Cont… Stopping,… <NA>        Control…
    #>  5 0     Medical and Surg… 3     Operation Crea… Putting i… Used for g… Creatio…
    #>  6 0     Medical and Surg… 3     Operation Dest… Physical … None of th… Fulgura…
    #>  7 0     Medical and Surg… 3     Operation Deta… Cutting o… The body p… Below k…
    #>  8 0     Medical and Surg… 3     Operation Dila… Expanding… The orific… Percuta…
    #>  9 0     Medical and Surg… 3     Operation Divi… Cutting i… All or a p… Spinal …
    #> 10 0     Medical and Surg… 3     Operation Drai… Taking or… The qualif… Thorace…
    #> # ℹ 907 more rows

### Obstetrics

``` r
pcs("10D20ZZ")
```

    #> # A tibble: 7 × 4
    #>   axis  name           code  label                          
    #>   <chr> <chr>          <chr> <chr>                          
    #> 1 1     Section        1     Obstetrics                     
    #> 2 2     Body System    0     Pregnancy                      
    #> 3 3     Root Operation D     Extraction                     
    #> 4 4     Body Part      2     Products of Conception, Ectopic
    #> 5 5     Approach       0     Open                           
    #> 6 6     Device         Z     No Device                      
    #> 7 7     Qualifier      Z     No Qualifier

### Placement

``` r
pcs("2W0UX0Z")
```

    #> # A tibble: 7 × 4
    #>   axis  name           code  label             
    #>   <chr> <chr>          <chr> <chr>             
    #> 1 1     Section        2     Placement         
    #> 2 2     Body System    W     Anatomical Regions
    #> 3 3     Root Operation 0     Change            
    #> 4 4     Body Region    U     Toe, Right        
    #> 5 5     Approach       X     External          
    #> 6 6     Device         0     Traction Apparatus
    #> 7 7     Qualifier      Z     No Qualifier

### Administration

``` r
pcs("3E1938X")
```

    #> # A tibble: 7 × 4
    #>   axis  name                 code  label                                       
    #>   <chr> <chr>                <chr> <chr>                                       
    #> 1 1     Section              3     Administration                              
    #> 2 2     Body System          E     Physiological Systems and Anatomical Regions
    #> 3 3     Root Operation       1     Irrigation                                  
    #> 4 4     Body System / Region 9     Nose                                        
    #> 5 5     Approach             3     Percutaneous                                
    #> 6 6     Substance            8     Irrigating Substance                        
    #> 7 7     Qualifier            X     Diagnostic

### Measurement and Monitoring

``` r
pcs("4B01XVZ")
```

    #> # A tibble: 7 × 4
    #>   axis  name              code  label                     
    #>   <chr> <chr>             <chr> <chr>                     
    #> 1 1     Section           4     Measurement and Monitoring
    #> 2 2     Body System       B     Physiological Devices     
    #> 3 3     Root Operation    0     Measurement               
    #> 4 4     Body System       1     Peripheral Nervous        
    #> 5 5     Approach          X     External                  
    #> 6 6     Function / Device V     Stimulator                
    #> 7 7     Qualifier         Z     No Qualifier

### Extracorporeal or Systemic Assistance and Performance

``` r
pcs("5A02110")
```

    #> # A tibble: 7 × 4
    #>   axis  name           code  label                                              
    #>   <chr> <chr>          <chr> <chr>                                              
    #> 1 1     Section        5     Extracorporeal or Systemic Assistance and Performa…
    #> 2 2     Body System    A     Physiological Systems                              
    #> 3 3     Root Operation 0     Assistance                                         
    #> 4 4     Body System    2     Cardiac                                            
    #> 5 5     Duration       1     Intermittent                                       
    #> 6 6     Function       1     Output                                             
    #> 7 7     Qualifier      0     Balloon Pump

### Extracorporeal or Systemic Therapies

``` r
pcs("6A0Z0ZZ")
```

    #> # A tibble: 7 × 4
    #>   axis  name           code  label                               
    #>   <chr> <chr>          <chr> <chr>                               
    #> 1 1     Section        6     Extracorporeal or Systemic Therapies
    #> 2 2     Body System    A     Physiological Systems               
    #> 3 3     Root Operation 0     Atmospheric Control                 
    #> 4 4     Body System    Z     None                                
    #> 5 5     Duration       0     Single                              
    #> 6 6     Qualifier      Z     No Qualifier                        
    #> 7 7     Qualifier      Z     No Qualifier

### Osteopathic

``` r
pcs("7W00X0Z")
```

    #> # A tibble: 7 × 4
    #>   axis  name           code  label               
    #>   <chr> <chr>          <chr> <chr>               
    #> 1 1     Section        7     Osteopathic         
    #> 2 2     Body System    W     Anatomical Regions  
    #> 3 3     Root Operation 0     Treatment           
    #> 4 4     Body Region    0     Head                
    #> 5 5     Approach       X     External            
    #> 6 6     Method         0     Articulatory-Raising
    #> 7 7     Qualifier      Z     None

### Other Procedures

``` r
pcs("8C01X6J")
```

    #> # A tibble: 7 × 4
    #>   axis  name           code  label              
    #>   <chr> <chr>          <chr> <chr>              
    #> 1 1     Section        8     Other Procedures   
    #> 2 2     Body System    C     Indwelling Device  
    #> 3 3     Root Operation 0     Other Procedures   
    #> 4 4     Body Region    1     Nervous System     
    #> 5 5     Approach       X     External           
    #> 6 6     Method         6     Collection         
    #> 7 7     Qualifier      J     Cerebrospinal Fluid

### Chiropractic

``` r
pcs("9WB0XBZ")
```

    #> # A tibble: 7 × 4
    #>   axis  name           code  label             
    #>   <chr> <chr>          <chr> <chr>             
    #> 1 1     Section        9     Chiropractic      
    #> 2 2     Body System    W     Anatomical Regions
    #> 3 3     Root Operation B     Manipulation      
    #> 4 4     Body Region    0     Head              
    #> 5 5     Approach       X     External          
    #> 6 6     Method         B     Non-Manual        
    #> 7 7     Qualifier      Z     None

### Imaging

``` r
pcs("B00B0ZZ")
```

    #> Error in `dplyr::tibble()`:
    #> ! Tibble columns must have compatible sizes.
    #> • Size 0: Existing data.
    #> • Size 3: Column `name`.
    #> ℹ Only values of size one are recycled.

### Nuclear Medicine

``` r
pcs("C0101ZZ")
```

    #> Error in `dplyr::tibble()`:
    #> ! Tibble columns must have compatible sizes.
    #> • Size 0: Existing data.
    #> • Size 3: Column `name`.
    #> ℹ Only values of size one are recycled.

### Radiation Therapy

``` r
pcs("DG22DZZ")
```

    #> Error in `dplyr::tibble()`:
    #> ! Tibble columns must have compatible sizes.
    #> • Size 0: Existing data.
    #> • Size 3: Column `name`.
    #> ℹ Only values of size one are recycled.

### Physical Rehabilitation and Diagnostic Audiology

``` r
pcs("F14Z01Z")
```

    #> Error in `dplyr::tibble()`:
    #> ! Tibble columns must have compatible sizes.
    #> • Size 0: Existing data.
    #> • Size 3: Column `name`.
    #> ℹ Only values of size one are recycled.

### Mental Health

``` r
pcs("GZ10ZZZ")
```

    #> Error in `dplyr::tibble()`:
    #> ! Tibble columns must have compatible sizes.
    #> • Size 0: Existing data.
    #> • Size 3: Column `name`.
    #> ℹ Only values of size one are recycled.

### Substance Abuse Treatment

``` r
pcs("HZ96ZZZ")
```

    #> Error in `dplyr::tibble()`:
    #> ! Tibble columns must have compatible sizes.
    #> • Size 0: Existing data.
    #> • Size 3: Column `name`.
    #> ℹ Only values of size one are recycled.

### New Technology

``` r
pcs("XY0YX37")
```

    #> # A tibble: 7 × 4
    #>   axis  name                            code  label                   
    #>   <chr> <chr>                           <chr> <chr>                   
    #> 1 1     Section                         X     New Technology          
    #> 2 2     Body System                     Y     Extracorporeal          
    #> 3 3     Root Operation                  0     Introduction            
    #> 4 4     Body Part                       Y     Extracorporeal          
    #> 5 5     Approach                        X     External                
    #> 6 6     Device / Substance / Technology 3     Nafamostat Anticoagulant
    #> 7 7     Qualifier                       7     New Technology Group 7

<br>

------------------------------------------------------------------------

## :balance_scale: Code of Conduct

Please note that the `provider` project is released with a [Contributor
Code of
Conduct](https://andrewallenbruce.github.io/procedural/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.

<br>

## :classical_building: Governance

This project is primarily maintained by [Andrew
Bruce](https://github.com/andrewallenbruce). Other authors may
occasionally assist with some of these duties.
