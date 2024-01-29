
<!-- README.md is generated from README.Rmd. Please edit that file -->

# procedural

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

    #> # A tibble: 19 × 6
    #>    section system table description                             codes    n_codes
    #>    <chr>   <chr>  <chr> <chr>                                   <list>     <dbl>
    #>  1 0       0L     0L2   Medical and Surgical, Tendons, Change   <tibble>       4
    #>  2 0       0L     0L5   Medical and Surgical, Tendons, Destruc… <tibble>      84
    #>  3 0       0L     0L8   Medical and Surgical, Tendons, Division <tibble>      84
    #>  4 0       0L     0L9   Medical and Surgical, Tendons, Drainage <tibble>     252
    #>  5 0       0L     0LB   Medical and Surgical, Tendons, Excision <tibble>     168
    #>  6 0       0L     0LC   Medical and Surgical, Tendons, Extirpa… <tibble>      84
    #>  7 0       0L     0LD   Medical and Surgical, Tendons, Extract… <tibble>      28
    #>  8 0       0L     0LH   Medical and Surgical, Tendons, Inserti… <tibble>       6
    #>  9 0       0L     0LJ   Medical and Surgical, Tendons, Inspect… <tibble>       8
    #> 10 0       0L     0LM   Medical and Surgical, Tendons, Reattac… <tibble>      56
    #> 11 0       0L     0LN   Medical and Surgical, Tendons, Release  <tibble>     112
    #> 12 0       0L     0LP   Medical and Surgical, Tendons, Removal  <tibble>      32
    #> 13 0       0L     0LQ   Medical and Surgical, Tendons, Repair   <tibble>      84
    #> 14 0       0L     0LR   Medical and Surgical, Tendons, Replace… <tibble>     168
    #> 15 0       0L     0LS   Medical and Surgical, Tendons, Reposit… <tibble>      56
    #> 16 0       0L     0LT   Medical and Surgical, Tendons, Resecti… <tibble>      56
    #> 17 0       0L     0LU   Medical and Surgical, Tendons, Supplem… <tibble>     168
    #> 18 0       0L     0LW   Medical and Surgical, Tendons, Revision <tibble>      38
    #> 19 0       0L     0LX   Medical and Surgical, Tendons, Transfer <tibble>      56

``` r
tables("0LQ")
```

    #> # A tibble: 1 × 6
    #>   section system table description                           codes    n_codes
    #>   <chr>   <chr>  <chr> <chr>                                 <list>     <dbl>
    #> 1 0       0L     0LQ   Medical and Surgical, Tendons, Repair <tibble>      84

``` r
tables("0LQ")$codes
```

    #> [[1]]
    #> # A tibble: 84 × 2
    #>    code    label                                                         
    #>    <chr>   <chr>                                                         
    #>  1 0LQ00ZZ Repair Head and Neck Tendon, Open Approach                    
    #>  2 0LQ03ZZ Repair Head and Neck Tendon, Percutaneous Approach            
    #>  3 0LQ04ZZ Repair Head and Neck Tendon, Percutaneous Endoscopic Approach 
    #>  4 0LQ10ZZ Repair Right Shoulder Tendon, Open Approach                   
    #>  5 0LQ13ZZ Repair Right Shoulder Tendon, Percutaneous Approach           
    #>  6 0LQ14ZZ Repair Right Shoulder Tendon, Percutaneous Endoscopic Approach
    #>  7 0LQ20ZZ Repair Left Shoulder Tendon, Open Approach                    
    #>  8 0LQ23ZZ Repair Left Shoulder Tendon, Percutaneous Approach            
    #>  9 0LQ24ZZ Repair Left Shoulder Tendon, Percutaneous Endoscopic Approach 
    #> 10 0LQ30ZZ Repair Right Upper Arm Tendon, Open Approach                  
    #> # ℹ 74 more rows

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

    #> # A tibble: 3 × 4
    #>   section              axis_name label                   value                  
    #>   <chr>                <chr>     <chr>                   <chr>                  
    #> 1 Medical and Surgical Approach  Open                    Cutting through the sk…
    #> 2 Medical and Surgical Approach  Percutaneous            Entry, by puncture or …
    #> 3 Medical and Surgical Approach  Percutaneous Endoscopic Entry, by puncture or …

``` r
pcs("0LQV3ZZ")
```

    #> # A tibble: 7 × 4
    #>   axis  name        value label               
    #>   <chr> <chr>       <chr> <chr>               
    #> 1 1     Section     0     Medical and Surgical
    #> 2 2     Body System L     Tendons             
    #> 3 3     Operation   Q     Repair              
    #> 4 4     Body Part   V     Foot Tendon, Right  
    #> 5 5     Approach    3     Percutaneous        
    #> 6 6     Device      Z     No Device           
    #> 7 7     Qualifier   Z     No Qualifier

## Codes

``` r
pcs("0G9000Z") # Medical and Surgical
```

    #> # A tibble: 7 × 4
    #>   axis  name        value label               
    #>   <chr> <chr>       <chr> <chr>               
    #> 1 1     Section     0     Medical and Surgical
    #> 2 2     Body System G     Endocrine System    
    #> 3 3     Operation   9     Drainage            
    #> 4 4     Body Part   0     Pituitary Gland     
    #> 5 5     Approach    0     Open                
    #> 6 6     Device      0     Drainage Device     
    #> 7 7     Qualifier   Z     No Qualifier

``` r
pcs("10D20ZZ") # Obstetrics
```

    #> # A tibble: 6 × 4
    #>   axis  name      value label                          
    #>   <chr> <chr>     <chr> <chr>                          
    #> 1 1     Section   1     Obstetrics                     
    #> 2 3     Operation D     Extraction                     
    #> 3 4     Body Part 2     Products of Conception, Ectopic
    #> 4 5     Approach  0     Open                           
    #> 5 6     Device    Z     No Device                      
    #> 6 7     Qualifier Z     No Qualifier

``` r
pcs("2W0UX0Z") # Placement
```

    #> # A tibble: 7 × 4
    #>   axis  name        value label             
    #>   <chr> <chr>       <chr> <chr>             
    #> 1 1     Section     2     Placement         
    #> 2 2     Body System W     Anatomical Regions
    #> 3 3     Operation   0     Change            
    #> 4 4     Body Region U     Toe, Right        
    #> 5 5     Approach    X     External          
    #> 6 6     Device      0     Traction Apparatus
    #> 7 7     Qualifier   Z     No Qualifier

``` r
pcs("3E1938X") # Administration
```

    #> # A tibble: 7 × 4
    #>   axis  name                 value label                                       
    #>   <chr> <chr>                <chr> <chr>                                       
    #> 1 1     Section              3     Administration                              
    #> 2 2     Body System          E     Physiological Systems and Anatomical Regions
    #> 3 3     Operation            1     Irrigation                                  
    #> 4 4     Body System / Region 9     Nose                                        
    #> 5 5     Approach             3     Percutaneous                                
    #> 6 6     Substance            8     Irrigating Substance                        
    #> 7 7     Qualifier            X     Diagnostic

``` r
pcs("4B01XVZ") # Measurement and Monitoring
```

    #> # A tibble: 7 × 4
    #>   axis  name              value label                     
    #>   <chr> <chr>             <chr> <chr>                     
    #> 1 1     Section           4     Measurement and Monitoring
    #> 2 2     Body System       B     Physiological Devices     
    #> 3 3     Operation         0     Measurement               
    #> 4 4     Body System       1     Peripheral Nervous        
    #> 5 5     Approach          X     External                  
    #> 6 6     Function / Device V     Stimulator                
    #> 7 7     Qualifier         Z     No Qualifier

``` r
pcs("5A02110") # Extracorporeal or Systemic Assistance and Performance
```

    #> # A tibble: 7 × 4
    #>   axis  name        value label                                                
    #>   <chr> <chr>       <chr> <chr>                                                
    #> 1 1     Section     5     Extracorporeal or Systemic Assistance and Performance
    #> 2 2     Body System A     Physiological Systems                                
    #> 3 3     Operation   0     Assistance                                           
    #> 4 4     Body System 2     Cardiac                                              
    #> 5 5     Duration    1     Intermittent                                         
    #> 6 6     Function    1     Output                                               
    #> 7 7     Qualifier   0     Balloon Pump

``` r
pcs("6A0Z0ZZ") # Extracorporeal or Systemic Therapies
```

    #> # A tibble: 7 × 4
    #>   axis  name        value label                               
    #>   <chr> <chr>       <chr> <chr>                               
    #> 1 1     Section     6     Extracorporeal or Systemic Therapies
    #> 2 2     Body System A     Physiological Systems               
    #> 3 3     Operation   0     Atmospheric Control                 
    #> 4 4     Body System Z     None                                
    #> 5 5     Duration    0     Single                              
    #> 6 6     Qualifier   Z     No Qualifier                        
    #> 7 7     Qualifier   Z     No Qualifier

``` r
pcs("7W00X0Z") # Osteopathic
```

    #> # A tibble: 7 × 4
    #>   axis  name        value label               
    #>   <chr> <chr>       <chr> <chr>               
    #> 1 1     Section     7     Osteopathic         
    #> 2 2     Body System W     Anatomical Regions  
    #> 3 3     Operation   0     Treatment           
    #> 4 4     Body Region 0     Head                
    #> 5 5     Approach    X     External            
    #> 6 6     Method      0     Articulatory-Raising
    #> 7 7     Qualifier   Z     None

``` r
pcs("8C01X6J") # Other Procedures
```

    #> # A tibble: 7 × 4
    #>   axis  name        value label              
    #>   <chr> <chr>       <chr> <chr>              
    #> 1 1     Section     8     Other Procedures   
    #> 2 2     Body System C     Indwelling Device  
    #> 3 3     Operation   0     Other Procedures   
    #> 4 4     Body Region 1     Nervous System     
    #> 5 5     Approach    X     External           
    #> 6 6     Method      6     Collection         
    #> 7 7     Qualifier   J     Cerebrospinal Fluid

``` r
pcs("9WB0XBZ") # Chiropractic
```

    #> # A tibble: 7 × 4
    #>   axis  name        value label             
    #>   <chr> <chr>       <chr> <chr>             
    #> 1 1     Section     9     Chiropractic      
    #> 2 2     Body System W     Anatomical Regions
    #> 3 3     Operation   B     Manipulation      
    #> 4 4     Body Region 0     Head              
    #> 5 5     Approach    X     External          
    #> 6 6     Method      B     Non-Manual        
    #> 7 7     Qualifier   Z     None

``` r
pcs("B00B0ZZ") # Imaging
```

    #> # A tibble: 7 × 4
    #>   axis  name        value label                 
    #>   <chr> <chr>       <chr> <chr>                 
    #> 1 1     Section     B     Imaging               
    #> 2 2     Body System 0     Central Nervous System
    #> 3 3     Type        0     Plain Radiography     
    #> 4 4     Body Part   B     Spinal Cord           
    #> 5 5     Contrast    0     High Osmolar          
    #> 6 6     Qualifier   Z     None                  
    #> 7 7     Qualifier   Z     None

``` r
pcs("C0101ZZ") # Nuclear Medicine
```

    #> # A tibble: 7 × 4
    #>   axis  name         value label                          
    #>   <chr> <chr>        <chr> <chr>                          
    #> 1 1     Section      C     Nuclear Medicine               
    #> 2 2     Body System  0     Central Nervous System         
    #> 3 3     Type         1     Planar Nuclear Medicine Imaging
    #> 4 4     Body Part    0     Brain                          
    #> 5 5     Radionuclide 1     Technetium 99m (Tc-99m)        
    #> 6 6     Qualifier    Z     None                           
    #> 7 7     Qualifier    Z     None

``` r
pcs("DG22DZZ") # Radiation Therapy
```

    #> # A tibble: 7 × 4
    #>   axis  name               value label                                 
    #>   <chr> <chr>              <chr> <chr>                                 
    #> 1 1     Section            D     Radiation Therapy                     
    #> 2 2     Body System        G     Endocrine System                      
    #> 3 3     Modality           2     Stereotactic Radiosurgery             
    #> 4 4     Treatment Site     2     Adrenal Glands                        
    #> 5 5     Modality Qualifier D     Stereotactic Other Photon Radiosurgery
    #> 6 6     Isotope            Z     None                                  
    #> 7 7     Qualifier          Z     None

``` r
pcs("F14Z01Z") # Physical Rehabilitation and Diagnostic Audiology
```

    #> # A tibble: 7 × 4
    #>   axis  name                 value label                                        
    #>   <chr> <chr>                <chr> <chr>                                        
    #> 1 1     Section              F     Physical Rehabilitation and Diagnostic Audio…
    #> 2 2     Section Qualifier    1     Diagnostic Audiology                         
    #> 3 3     Type                 4     Hearing Aid Assessment                       
    #> 4 4     Body System / Region Z     None                                         
    #> 5 5     Type Qualifier       0     Cochlear Implant                             
    #> 6 6     Equipment            1     Audiometer                                   
    #> 7 7     Qualifier            Z     None

``` r
pcs("GZ10ZZZ") # Mental Health
```

    #> # A tibble: 7 × 4
    #>   axis  name        value label              
    #>   <chr> <chr>       <chr> <chr>              
    #> 1 1     Section     G     Mental Health      
    #> 2 2     Body System Z     None               
    #> 3 3     Type        1     Psychological Tests
    #> 4 4     Qualifier   0     Developmental      
    #> 5 5     Qualifier   Z     None               
    #> 6 6     Qualifier   Z     None               
    #> 7 7     Qualifier   Z     None

``` r
pcs("HZ96ZZZ") # Substance Abuse Treatment
```

    #> # A tibble: 7 × 4
    #>   axis  name        value label                    
    #>   <chr> <chr>       <chr> <chr>                    
    #> 1 1     Section     H     Substance Abuse Treatment
    #> 2 2     Body System Z     None                     
    #> 3 3     Type        9     Pharmacotherapy          
    #> 4 4     Qualifier   6     Clonidine                
    #> 5 5     Qualifier   Z     None                     
    #> 6 6     Qualifier   Z     None                     
    #> 7 7     Qualifier   Z     None

``` r
pcs("XY0YX37") # New Technology
```

    #> # A tibble: 7 × 4
    #>   axis  name                            value label                   
    #>   <chr> <chr>                           <chr> <chr>                   
    #> 1 1     Section                         X     New Technology          
    #> 2 2     Body System                     Y     Extracorporeal          
    #> 3 3     Operation                       0     Introduction            
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
