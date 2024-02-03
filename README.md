
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

## Definitions

``` r
definitions(section = "0", axis = "5") |> 
  dplyr::select(label, definition)
```

    #> # A tibble: 7 × 2
    #>   label                                                               definition
    #>   <chr>                                                               <chr>     
    #> 1 External                                                            Procedure…
    #> 2 Open                                                                Cutting t…
    #> 3 Percutaneous                                                        Entry, by…
    #> 4 Percutaneous Endoscopic                                             Entry, by…
    #> 5 Via Natural or Artificial Opening                                   Entry of …
    #> 6 Via Natural or Artificial Opening Endoscopic                        Entry of …
    #> 7 Via Natural or Artificial Opening With Percutaneous Endoscopic Ass… Entry of …

``` r
pcs("0LQV3ZZ")
```

    #> $description
    #> [1] "Repair Right Foot Tendon, Percutaneous Approach"
    #> 
    #> $code
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

    #> $description
    #> [1] "Drainage of Pituitary Gland with Drainage Device, Open Approach"
    #> 
    #> $code
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

    #> $description
    #> [1] "Extraction of Products of Conception, Ectopic, Open Approach"
    #> 
    #> $code
    #> # A tibble: 7 × 4
    #>   axis  name        value label                          
    #>   <chr> <chr>       <chr> <chr>                          
    #> 1 1     Section     1     Obstetrics                     
    #> 2 2     Body System 0     Pregnancy                      
    #> 3 3     Operation   D     Extraction                     
    #> 4 4     Body Part   2     Products of Conception, Ectopic
    #> 5 5     Approach    0     Open                           
    #> 6 6     Device      Z     No Device                      
    #> 7 7     Qualifier   Z     No Qualifier

``` r
pcs("2W0UX0Z") # Placement
```

    #> $description
    #> [1] "Change Traction Apparatus on Right Toe"
    #> 
    #> $code
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

    #> $description
    #> [1] "Irrigation of Nose using Irrigating Substance, Percutaneous Approach, Diagnostic"
    #> 
    #> $code
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

    #> $description
    #> [1] "Measurement of Peripheral Nervous Stimulator, External Approach"
    #> 
    #> $code
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

    #> $description
    #> [1] "Assistance with Cardiac Output using Balloon Pump, Intermittent"
    #> 
    #> $code
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

    #> $description
    #> [1] "Atmospheric Control, Single"
    #> 
    #> $code
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

    #> $description
    #> [1] "Osteopathic Treatment of Head using Articulatory-Raising Forces"
    #> 
    #> $code
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

    #> $description
    #> [1] "Collection of Cerebrospinal Fluid from Indwelling Device in Nervous System"
    #> 
    #> $code
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

    #> $description
    #> [1] "Chiropractic Manipulation of Head, Non-Manual"
    #> 
    #> $code
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

    #> $description
    #> [1] "Plain Radiography of Spinal Cord using High Osmolar Contrast"
    #> 
    #> $code
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

    #> $description
    #> [1] "Planar Nuclear Medicine Imaging of Brain using Technetium 99m (Tc-99m)"
    #> 
    #> $code
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

    #> $description
    #> [1] "Stereotactic Other Photon Radiosurgery of Adrenal Glands"
    #> 
    #> $code
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

    #> $description
    #> [1] "Cochlear Implant Assessment using Audiometer"
    #> 
    #> $code
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

    #> $description
    #> [1] "Psychological Tests, Developmental"
    #> 
    #> $code
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

    #> $description
    #> [1] "Pharmacotherapy for Substance Abuse Treatment, Clonidine"
    #> 
    #> $code
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

    #> $description
    #> [1] "Extracorporeal Introduction of Nafamostat Anticoagulant, New Technology Group 7"
    #> 
    #> $code
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
