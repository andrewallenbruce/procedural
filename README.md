
<!-- README.md is generated from README.Rmd. Please edit that file -->

# `procedural` <a href="https://andrewallenbruce.github.io/procedural/"><img src="man/figures/logo.png" align="right" height="139" alt="procedural website" /></a>

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![Codecov test
coverage](https://codecov.io/gh/andrewallenbruce/procedural/branch/main/graph/badge.svg)](https://app.codecov.io/gh/andrewallenbruce/procedural?branch=main)
[![R-CMD-check](https://github.com/andrewallenbruce/procedural/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/andrewallenbruce/procedural/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of **`procedural`** is to provide a set of tools for working
with the **2024 ICD-10-PCS** procedure classification system.

# :package: Installation

You can install **`procedural`** from [GitHub](https://github.com/)
with:

``` r
# install.packages("pak")
pak::pak("andrewallenbruce/procedural")
```

# :beginner: Usage

``` r
library(procedural)
```

**ICD-10-PCS**, or **the International Classification of Diseases, 10th
Revision, Procedure Coding System**, is a procedure classification
system used to code procedures performed in hospital inpatient health
care settings.

## Index

``` r
index(search = "Achillorrhaphy")
```

    #> # A tibble: 1 × 6
    #>      id index term           type  value           code 
    #>   <int> <chr> <chr>          <chr> <chr>           <chr>
    #> 1    38 A     Achillorrhaphy See   Repair, Tendons 0LQ

## Tables

``` r
tables("0L")
```

    #> # A tibble: 1,544 × 3
    #>    order code    description                                                    
    #>    <int> <chr>   <chr>                                                          
    #>  1 40241 0L2XX0Z Change Drainage Device in Upper Tendon, External Approach      
    #>  2 40242 0L2XXYZ Change Other Device in Upper Tendon, External Approach         
    #>  3 40243 0L2YX0Z Change Drainage Device in Lower Tendon, External Approach      
    #>  4 40244 0L2YXYZ Change Other Device in Lower Tendon, External Approach         
    #>  5 40245 0L500ZZ Destruction of Head and Neck Tendon, Open Approach             
    #>  6 40246 0L503ZZ Destruction of Head and Neck Tendon, Percutaneous Approach     
    #>  7 40247 0L504ZZ Destruction of Head and Neck Tendon, Percutaneous Endoscopic A…
    #>  8 40248 0L510ZZ Destruction of Right Shoulder Tendon, Open Approach            
    #>  9 40249 0L513ZZ Destruction of Right Shoulder Tendon, Percutaneous Approach    
    #> 10 40250 0L514ZZ Destruction of Right Shoulder Tendon, Percutaneous Endoscopic …
    #> # ℹ 1,534 more rows

``` r
tables("0LQ")
```

    #> # A tibble: 84 × 3
    #>    order code    description                                                   
    #>    <int> <chr>   <chr>                                                         
    #>  1 41159 0LQ00ZZ Repair Head and Neck Tendon, Open Approach                    
    #>  2 41160 0LQ03ZZ Repair Head and Neck Tendon, Percutaneous Approach            
    #>  3 41161 0LQ04ZZ Repair Head and Neck Tendon, Percutaneous Endoscopic Approach 
    #>  4 41162 0LQ10ZZ Repair Right Shoulder Tendon, Open Approach                   
    #>  5 41163 0LQ13ZZ Repair Right Shoulder Tendon, Percutaneous Approach           
    #>  6 41164 0LQ14ZZ Repair Right Shoulder Tendon, Percutaneous Endoscopic Approach
    #>  7 41165 0LQ20ZZ Repair Left Shoulder Tendon, Open Approach                    
    #>  8 41166 0LQ23ZZ Repair Left Shoulder Tendon, Percutaneous Approach            
    #>  9 41167 0LQ24ZZ Repair Left Shoulder Tendon, Percutaneous Endoscopic Approach 
    #> 10 41168 0LQ30ZZ Repair Right Upper Arm Tendon, Open Approach                  
    #> # ℹ 74 more rows

``` r
tables("0LQ")$codes
```

    #> NULL

## Rows

``` r
rows("0LQ")
```

    #> # A tibble: 28 × 5
    #>    table row   description                                  rowid axes        
    #>    <chr> <chr> <chr>                                        <int> <named list>
    #>  1 0LQ   0LQ0  Body Part, Head and Neck Tendon                983 <tibble>    
    #>  2 0LQ   0LQ1  Body Part, Shoulder Tendon, Right              983 <tibble>    
    #>  3 0LQ   0LQ2  Body Part, Shoulder Tendon, Left               983 <tibble>    
    #>  4 0LQ   0LQ3  Body Part, Upper Arm Tendon, Right             983 <tibble>    
    #>  5 0LQ   0LQ4  Body Part, Upper Arm Tendon, Left              983 <tibble>    
    #>  6 0LQ   0LQ5  Body Part, Lower Arm and Wrist Tendon, Right   983 <tibble>    
    #>  7 0LQ   0LQ6  Body Part, Lower Arm and Wrist Tendon, Left    983 <tibble>    
    #>  8 0LQ   0LQ7  Body Part, Hand Tendon, Right                  983 <tibble>    
    #>  9 0LQ   0LQ8  Body Part, Hand Tendon, Left                   983 <tibble>    
    #> 10 0LQ   0LQ9  Body Part, Trunk Tendon, Right                 983 <tibble>    
    #> # ℹ 18 more rows

``` r
rows("0LQ0")
```

    #> # A tibble: 1 × 5
    #>   table row   description                     rowid axes            
    #>   <chr> <chr> <chr>                           <int> <named list>    
    #> 1 0LQ   0LQ0  Body Part, Head and Neck Tendon   983 <tibble [5 × 4]>

``` r
rows("0LQ0")$axes
```

    #> $row_983.0LQ0
    #> # A tibble: 5 × 4
    #>   axis  title     code  label                  
    #>   <chr> <chr>     <chr> <chr>                  
    #> 1 5     Approach  0     Open                   
    #> 2 5     Approach  3     Percutaneous           
    #> 3 5     Approach  4     Percutaneous Endoscopic
    #> 4 6     Device    Z     No Device              
    #> 5 7     Qualifier Z     No Qualifier

## Definitions

``` r
definitions(section = "0", 
            axis = "5") |> 
  dplyr::filter(axis_code %in% c("0", "3", "4")) |> 
  tidyr::unnest(elements) |> 
  dplyr::select(section, axis_name, label, value)
```

    #> Error in `dplyr::filter()`:
    #> ℹ In argument: `axis_code %in% c("0", "3", "4")`.
    #> Caused by error:
    #> ! object 'axis_code' not found

``` r
pcs("0LQV3ZZ")
```

    #> $input
    #> [1] "0LQV3ZZ"
    #> 
    #> $head
    #> # A tibble: 4 × 4
    #>   axis  name        value label               
    #>   <chr> <chr>       <chr> <chr>               
    #> 1 1     Section     0     Medical and Surgical
    #> 2 2     Body System L     Tendons             
    #> 3 3     Operation   Q     Repair              
    #> 4 4     Body Part   V     Foot Tendon, Right  
    #> 
    #> $id
    #> [1] 983
    #> 
    #> $tail
    #>   rowid axis      name value        label
    #> 1   983    5  Approach     3 Percutaneous
    #> 2   983    6    Device     Z    No Device
    #> 3   983    7 Qualifier     Z No Qualifier

## Codes

``` r
pcs("0G9000Z") # Medical and Surgical
```

    #> $input
    #> [1] "0G9000Z"
    #> 
    #> $head
    #> # A tibble: 4 × 4
    #>   axis  name        value label               
    #>   <chr> <chr>       <chr> <chr>               
    #> 1 1     Section     0     Medical and Surgical
    #> 2 2     Body System G     Endocrine System    
    #> 3 3     Operation   9     Drainage            
    #> 4 4     Body Part   0     Pituitary Gland     
    #> 
    #> $id
    #> [1] 834
    #> 
    #> $tail
    #>   rowid axis      name value           label
    #> 1   834    5  Approach     0            Open
    #> 2   835    5  Approach     0            Open
    #> 3   834    6    Device     0 Drainage Device
    #> 4   834    7 Qualifier     Z    No Qualifier
    #> 5   835    7 Qualifier     Z    No Qualifier

``` r
pcs("10D20ZZ") # Obstetrics
```

    #> $input
    #> [1] "10D20ZZ"
    #> 
    #> $head
    #> # A tibble: 4 × 4
    #>   axis  name        value label                          
    #>   <chr> <chr>       <chr> <chr>                          
    #> 1 1     Section     1     Obstetrics                     
    #> 2 2     Body System 0     Pregnancy                      
    #> 3 3     Operation   D     Extraction                     
    #> 4 4     Body Part   2     Products of Conception, Ectopic
    #> 
    #> $id
    #> [1] 1548
    #> 
    #> $tail
    #>   rowid axis      name value        label
    #> 1  1548    5  Approach     0         Open
    #> 2  1548    6    Device     Z    No Device
    #> 3  1548    7 Qualifier     Z No Qualifier

``` r
pcs("2W0UX0Z") # Placement
```

    #> $input
    #> [1] "2W0UX0Z"
    #> 
    #> $head
    #> # A tibble: 4 × 4
    #>   axis  name        value label             
    #>   <chr> <chr>       <chr> <chr>             
    #> 1 1     Section     2     Placement         
    #> 2 2     Body System W     Anatomical Regions
    #> 3 3     Operation   0     Change            
    #> 4 4     Body Region U     Toe, Right        
    #> 
    #> $id
    #> [1] 1558
    #> 
    #> $tail
    #>   rowid axis      name value              label
    #> 1  1558    5  Approach     X           External
    #> 2  1558    6    Device     0 Traction Apparatus
    #> 3  1558    7 Qualifier     Z       No Qualifier

``` r
pcs("3E1938X") # Administration
```

    #> $input
    #> [1] "3E1938X"
    #> 
    #> $head
    #> # A tibble: 4 × 4
    #>   axis  name                 value label                                       
    #>   <chr> <chr>                <chr> <chr>                                       
    #> 1 1     Section              3     Administration                              
    #> 2 2     Body System          E     Physiological Systems and Anatomical Regions
    #> 3 3     Operation            1     Irrigation                                  
    #> 4 4     Body System / Region 9     Nose                                        
    #> 
    #> $id
    #> [1] 1768
    #> 
    #> $tail
    #>   rowid axis      name value                label
    #> 1  1768    5  Approach     3         Percutaneous
    #> 2  1768    6 Substance     8 Irrigating Substance
    #> 3  1768    7 Qualifier     X           Diagnostic

``` r
pcs("4B01XVZ") # Measurement and Monitoring
```

    #> $input
    #> [1] "4B01XVZ"
    #> 
    #> $head
    #> # A tibble: 4 × 4
    #>   axis  name        value label                     
    #>   <chr> <chr>       <chr> <chr>                     
    #> 1 1     Section     4     Measurement and Monitoring
    #> 2 2     Body System B     Physiological Devices     
    #> 3 3     Operation   0     Measurement               
    #> 4 4     Body System 1     Peripheral Nervous        
    #> 
    #> $id
    #> [1] 1841
    #> 
    #> $tail
    #>   rowid axis              name value        label
    #> 1  1841    5          Approach     X     External
    #> 2  1841    6 Function / Device     V   Stimulator
    #> 3  1841    7         Qualifier     Z No Qualifier

``` r
pcs("5A02110") # Extracorporeal or Systemic Assistance and Performance
```

    #> $input
    #> [1] "5A02110"
    #> 
    #> $head
    #> # A tibble: 4 × 4
    #>   axis  name        value label                                                
    #>   <chr> <chr>       <chr> <chr>                                                
    #> 1 1     Section     5     Extracorporeal or Systemic Assistance and Performance
    #> 2 2     Body System A     Physiological Systems                                
    #> 3 3     Operation   0     Assistance                                           
    #> 4 4     Body System 2     Cardiac                                              
    #> 
    #> $id
    #> [1] 1844
    #> 
    #> $tail
    #>   rowid axis      name value        label
    #> 1  1844    5  Duration     1 Intermittent
    #> 2  1844    6  Function     1       Output
    #> 3  1845    6  Function     1       Output
    #> 4  1844    7 Qualifier     0 Balloon Pump
    #> 5  1845    7 Qualifier     0 Balloon Pump

``` r
pcs("6A0Z0ZZ") # Extracorporeal or Systemic Therapies
```

    #> $input
    #> [1] "6A0Z0ZZ"
    #> 
    #> $head
    #> # A tibble: 4 × 4
    #>   axis  name        value label                               
    #>   <chr> <chr>       <chr> <chr>                               
    #> 1 1     Section     6     Extracorporeal or Systemic Therapies
    #> 2 2     Body System A     Physiological Systems               
    #> 3 3     Operation   0     Atmospheric Control                 
    #> 4 4     Body System Z     None                                
    #> 
    #> $id
    #> [1] 1861
    #> 
    #> $tail
    #>   rowid axis      name value        label
    #> 1  1861    5  Duration     0       Single
    #> 2  1861    6 Qualifier     Z No Qualifier
    #> 3  1861    7 Qualifier     Z No Qualifier

``` r
pcs("7W00X0Z") # Osteopathic
```

    #> $input
    #> [1] "7W00X0Z"
    #> 
    #> $head
    #> # A tibble: 4 × 4
    #>   axis  name        value label             
    #>   <chr> <chr>       <chr> <chr>             
    #> 1 1     Section     7     Osteopathic       
    #> 2 2     Body System W     Anatomical Regions
    #> 3 3     Operation   0     Treatment         
    #> 4 4     Body Region 0     Head              
    #> 
    #> $id
    #> [1] 1872
    #> 
    #> $tail
    #>   rowid axis      name value                label
    #> 1  1872    5  Approach     X             External
    #> 2  1872    6    Method     0 Articulatory-Raising
    #> 3  1872    7 Qualifier     Z                 None

``` r
pcs("8C01X6J") # Other Procedures
```

    #> $input
    #> [1] "8C01X6J"
    #> 
    #> $head
    #> # A tibble: 4 × 4
    #>   axis  name        value label            
    #>   <chr> <chr>       <chr> <chr>            
    #> 1 1     Section     8     Other Procedures 
    #> 2 2     Body System C     Indwelling Device
    #> 3 3     Operation   0     Other Procedures 
    #> 4 4     Body Region 1     Nervous System   
    #> 
    #> $id
    #> [1] 1873
    #> 
    #> $tail
    #>   rowid axis      name value               label
    #> 1  1873    5  Approach     X            External
    #> 2  1873    6    Method     6          Collection
    #> 3  1873    7 Qualifier     J Cerebrospinal Fluid

``` r
pcs("9WB0XBZ") # Chiropractic
```

    #> $input
    #> [1] "9WB0XBZ"
    #> 
    #> $head
    #> # A tibble: 4 × 4
    #>   axis  name        value label             
    #>   <chr> <chr>       <chr> <chr>             
    #> 1 1     Section     9     Chiropractic      
    #> 2 2     Body System W     Anatomical Regions
    #> 3 3     Operation   B     Manipulation      
    #> 4 4     Body Region 0     Head              
    #> 
    #> $id
    #> [1] 1902
    #> 
    #> $tail
    #>   rowid axis      name value      label
    #> 1  1902    5  Approach     X   External
    #> 2  1902    6    Method     B Non-Manual
    #> 3  1902    7 Qualifier     Z       None

``` r
pcs("B00B0ZZ") # Imaging
```

    #> $input
    #> [1] "B00B0ZZ"
    #> 
    #> $head
    #> # A tibble: 4 × 4
    #>   axis  name        value label                 
    #>   <chr> <chr>       <chr> <chr>                 
    #> 1 1     Section     B     Imaging               
    #> 2 2     Body System 0     Central Nervous System
    #> 3 3     Type        0     Plain Radiography     
    #> 4 4     Body Part   B     Spinal Cord           
    #> 
    #> $id
    #> [1] 1903
    #> 
    #> $tail
    #>   rowid axis      name value        label
    #> 1  1903    5  Contrast     0 High Osmolar
    #> 2  1903    6 Qualifier     Z         None
    #> 3  1903    7 Qualifier     Z         None

``` r
pcs("C0101ZZ") # Nuclear Medicine
```

    #> $input
    #> [1] "C0101ZZ"
    #> 
    #> $head
    #> # A tibble: 4 × 4
    #>   axis  name        value label                          
    #>   <chr> <chr>       <chr> <chr>                          
    #> 1 1     Section     C     Nuclear Medicine               
    #> 2 2     Body System 0     Central Nervous System         
    #> 3 3     Type        1     Planar Nuclear Medicine Imaging
    #> 4 4     Body Part   0     Brain                          
    #> 
    #> $id
    #> [1] 2065
    #> 
    #> $tail
    #>   rowid axis         name value                   label
    #> 1  2065    5 Radionuclide     1 Technetium 99m (Tc-99m)
    #> 2  2065    6    Qualifier     Z                    None
    #> 3  2065    7    Qualifier     Z                    None

``` r
pcs("DG22DZZ") # Radiation Therapy
```

    #> $input
    #> [1] "DG22DZZ"
    #> 
    #> $head
    #> # A tibble: 4 × 4
    #>   axis  name           value label                    
    #>   <chr> <chr>          <chr> <chr>                    
    #> 1 1     Section        D     Radiation Therapy        
    #> 2 2     Body System    G     Endocrine System         
    #> 3 3     Modality       2     Stereotactic Radiosurgery
    #> 4 4     Treatment Site 2     Adrenal Glands           
    #> 
    #> $id
    #> [1] 2213
    #> 
    #> $tail
    #>   rowid axis               name value                                  label
    #> 1  2213    5 Modality Qualifier     D Stereotactic Other Photon Radiosurgery
    #> 2  2213    6            Isotope     Z                                   None
    #> 3  2213    7          Qualifier     Z                                   None

``` r
pcs("F14Z01Z") # Physical Rehabilitation and Diagnostic Audiology
```

    #> $input
    #> [1] "F14Z01Z"
    #> 
    #> $head
    #> # A tibble: 4 × 4
    #>   axis  name                 value label                                        
    #>   <chr> <chr>                <chr> <chr>                                        
    #> 1 1     Section              F     Physical Rehabilitation and Diagnostic Audio…
    #> 2 2     Section Qualifier    1     Diagnostic Audiology                         
    #> 3 3     Type                 4     Hearing Aid Assessment                       
    #> 4 4     Body System / Region Z     None                                         
    #> 
    #> $id
    #> [1] 2351
    #> 
    #> $tail
    #>    rowid axis           name value            label
    #> 1   2351    5 Type Qualifier     0 Cochlear Implant
    #> 2   2351    6      Equipment     1       Audiometer
    #> 3   2353    6      Equipment     1       Audiometer
    #> 4   2354    6      Equipment     1       Audiometer
    #> 5   2355    6      Equipment     1       Audiometer
    #> 6   2351    7      Qualifier     Z             None
    #> 7   2352    7      Qualifier     Z             None
    #> 8   2353    7      Qualifier     Z             None
    #> 9   2354    7      Qualifier     Z             None
    #> 10  2355    7      Qualifier     Z             None
    #> 11  2356    7      Qualifier     Z             None

``` r
pcs("GZ10ZZZ") # Mental Health
```

    #> $input
    #> [1] "GZ10ZZZ"
    #> 
    #> $head
    #> # A tibble: 4 × 4
    #>   axis  name        value label              
    #>   <chr> <chr>       <chr> <chr>              
    #> 1 1     Section     G     Mental Health      
    #> 2 2     Body System Z     None               
    #> 3 3     Type        1     Psychological Tests
    #> 4 4     Qualifier   0     Developmental      
    #> 
    #> $id
    #> [1] 2359
    #> 
    #> $tail
    #>   rowid axis      name value label
    #> 1  2359    5 Qualifier     Z  None
    #> 2  2359    6 Qualifier     Z  None
    #> 3  2359    7 Qualifier     Z  None

``` r
pcs("HZ96ZZZ") # Substance Abuse Treatment
```

    #> $input
    #> [1] "HZ96ZZZ"
    #> 
    #> $head
    #> # A tibble: 4 × 4
    #>   axis  name        value label                    
    #>   <chr> <chr>       <chr> <chr>                    
    #> 1 1     Section     H     Substance Abuse Treatment
    #> 2 2     Body System Z     None                     
    #> 3 3     Type        9     Pharmacotherapy          
    #> 4 4     Qualifier   6     Clonidine                
    #> 
    #> $id
    #> [1] 2377
    #> 
    #> $tail
    #>   rowid axis      name value label
    #> 1  2377    5 Qualifier     Z  None
    #> 2  2377    6 Qualifier     Z  None
    #> 3  2377    7 Qualifier     Z  None

``` r
pcs("XY0YX37") # New Technology
```

    #> $input
    #> [1] "XY0YX37"
    #> 
    #> $head
    #> # A tibble: 4 × 4
    #>   axis  name        value label         
    #>   <chr> <chr>       <chr> <chr>         
    #> 1 1     Section     X     New Technology
    #> 2 2     Body System Y     Extracorporeal
    #> 3 3     Operation   0     Introduction  
    #> 4 4     Body Part   Y     Extracorporeal
    #> 
    #> $id
    #> [1] 2586
    #> 
    #> $tail
    #>   rowid axis                            name value                    label
    #> 1  2585    5                        Approach     X                 External
    #> 2  2586    5                        Approach     X                 External
    #> 3  2586    6 Device / Substance / Technology     3 Nafamostat Anticoagulant
    #> 4  2586    7                       Qualifier     7   New Technology Group 7

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
