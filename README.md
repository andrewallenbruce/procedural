
<!-- README.md is generated from README.Rmd. Please edit that file -->

# procedural <a href="https://andrewallenbruce.github.io/procedural/"><img src="man/figures/logo.png" align="right" height="139" alt="procedural website" /></a>

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![Codecov test
coverage](https://codecov.io/gh/andrewallenbruce/procedural/branch/main/graph/badge.svg)](https://app.codecov.io/gh/andrewallenbruce/procedural?branch=main)
[![R-CMD-check](https://github.com/andrewallenbruce/procedural/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/andrewallenbruce/procedural/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of **procedural** is to provide a set of tools for working with
the **2024 ICD-10-PCS** procedure classification system.

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

## Codes

``` r
pcs("0LQV3ZZ") # Medical and Surgical
```

    #> $code
    #> [1] "0LQV3ZZ"
    #> 
    #> $description
    #> [1] "Repair Right Foot Tendon, Percutaneous Approach"
    #> 
    #> $axes
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
    #> 
    #> $definitions
    #> # A tibble: 2 × 6
    #>   section axis  name      value label        definition                         
    #>   <chr>   <chr> <chr>     <chr> <chr>        <chr>                              
    #> 1 0       3     Operation Q     Repair       Restoring, to the extent possible,…
    #> 2 0       5     Approach  3     Percutaneous Entry, by puncture or minor incisi…
    #> 
    #> $includes
    #> [1] NA

``` r
pcs("0G9000Z") # Medical and Surgical
```

    #> $code
    #> [1] "0G9000Z"
    #> 
    #> $description
    #> [1] "Drainage of Pituitary Gland with Drainage Device, Open Approach"
    #> 
    #> $axes
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
    #> 
    #> $definitions
    #> # A tibble: 2 × 6
    #>   section axis  name      value label    definition                             
    #>   <chr>   <chr> <chr>     <chr> <chr>    <chr>                                  
    #> 1 0       3     Operation 9     Drainage Taking or letting out fluids and/or ga…
    #> 2 0       5     Approach  0     Open     Cutting through the skin or mucous mem…
    #> 
    #> $includes
    #> # A tibble: 1 × 5
    #>   section axis  name      label           includes                              
    #>   <chr>   <chr> <chr>     <chr>           <chr>                                 
    #> 1 0       4     Body Part Pituitary Gland Adenohypophysis, Hypophysis, Neurohyp…

``` r
pcs("10D20ZZ") # Obstetrics
```

    #> $code
    #> [1] "10D20ZZ"
    #> 
    #> $description
    #> [1] "Extraction of Products of Conception, Ectopic, Open Approach"
    #> 
    #> $axes
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
    #> 
    #> $definitions
    #> # A tibble: 2 × 6
    #>   section axis  name      value label      definition                           
    #>   <chr>   <chr> <chr>     <chr> <chr>      <chr>                                
    #> 1 1       3     Operation D     Extraction Pulling or stripping out or off all …
    #> 2 1       5     Approach  0     Open       Cutting through the skin or mucous m…
    #> 
    #> $includes
    #> [1] NA

``` r
pcs("2W0UX0Z") # Placement
```

    #> $code
    #> [1] "2W0UX0Z"
    #> 
    #> $description
    #> [1] "Change Traction Apparatus on Right Toe"
    #> 
    #> $axes
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
    #> 
    #> $definitions
    #> # A tibble: 2 × 6
    #>   section axis  name      value label    definition                             
    #>   <chr>   <chr> <chr>     <chr> <chr>    <chr>                                  
    #> 1 2       3     Operation 0     Change   Taking out or off a device from a body…
    #> 2 2       5     Approach  X     External Procedures performed directly on the s…
    #> 
    #> $includes
    #> [1] NA

``` r
pcs("3E1938X") # Administration
```

    #> $code
    #> [1] "3E1938X"
    #> 
    #> $description
    #> [1] "Irrigation of Nose using Irrigating Substance, Percutaneous Approach, Diagnostic"
    #> 
    #> $axes
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
    #> 
    #> $definitions
    #> # A tibble: 2 × 6
    #>   section axis  name      value label        definition                         
    #>   <chr>   <chr> <chr>     <chr> <chr>        <chr>                              
    #> 1 3       3     Operation 1     Irrigation   Putting in or on a cleansing subst…
    #> 2 3       5     Approach  3     Percutaneous Entry, by puncture or minor incisi…
    #> 
    #> $includes
    #> [1] NA

``` r
pcs("4B01XVZ") # Measurement and Monitoring
```

    #> $code
    #> [1] "4B01XVZ"
    #> 
    #> $description
    #> [1] "Measurement of Peripheral Nervous Stimulator, External Approach"
    #> 
    #> $axes
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
    #> 
    #> $definitions
    #> # A tibble: 2 × 6
    #>   section axis  name      value label       definition                          
    #>   <chr>   <chr> <chr>     <chr> <chr>       <chr>                               
    #> 1 4       3     Operation 0     Measurement Determining the level of a physiolo…
    #> 2 4       5     Approach  X     External    Procedures performed directly on th…
    #> 
    #> $includes
    #> [1] NA

``` r
pcs("5A02110") # Extracorporeal or Systemic Assistance and Performance
```

    #> $code
    #> [1] "5A02110"
    #> 
    #> $description
    #> [1] "Assistance with Cardiac Output using Balloon Pump, Intermittent"
    #> 
    #> $axes
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
    #> 
    #> $definitions
    #> [1] NA
    #> 
    #> $includes
    #> [1] NA

``` r
pcs("6A0Z0ZZ") # Extracorporeal or Systemic Therapies
```

    #> $code
    #> [1] "6A0Z0ZZ"
    #> 
    #> $description
    #> [1] "Atmospheric Control, Single"
    #> 
    #> $axes
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
    #> 
    #> $definitions
    #> [1] NA
    #> 
    #> $includes
    #> [1] NA

``` r
pcs("7W00X0Z") # Osteopathic
```

    #> $code
    #> [1] "7W00X0Z"
    #> 
    #> $description
    #> [1] "Osteopathic Treatment of Head using Articulatory-Raising Forces"
    #> 
    #> $axes
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
    #> 
    #> $definitions
    #> # A tibble: 2 × 6
    #>   section axis  name      value label     definition                            
    #>   <chr>   <chr> <chr>     <chr> <chr>     <chr>                                 
    #> 1 7       3     Operation 0     Treatment Manual treatment to eliminate or alle…
    #> 2 7       5     Approach  X     External  Procedures performed directly on the …
    #> 
    #> $includes
    #> [1] NA

``` r
pcs("8C01X6J") # Other Procedures
```

    #> $code
    #> [1] "8C01X6J"
    #> 
    #> $description
    #> [1] "Collection of Cerebrospinal Fluid from Indwelling Device in Nervous System"
    #> 
    #> $axes
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
    #> 
    #> $definitions
    #> # A tibble: 2 × 6
    #>   section axis  name      value label            definition                     
    #>   <chr>   <chr> <chr>     <chr> <chr>            <chr>                          
    #> 1 8       3     Operation 0     Other Procedures Methodologies which attempt to…
    #> 2 8       5     Approach  X     External         Procedures performed directly …
    #> 
    #> $includes
    #> [1] NA

``` r
pcs("9WB0XBZ") # Chiropractic
```

    #> $code
    #> [1] "9WB0XBZ"
    #> 
    #> $description
    #> [1] "Chiropractic Manipulation of Head, Non-Manual"
    #> 
    #> $axes
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
    #> 
    #> $definitions
    #> # A tibble: 2 × 6
    #>   section axis  name      value label        definition                         
    #>   <chr>   <chr> <chr>     <chr> <chr>        <chr>                              
    #> 1 9       3     Operation B     Manipulation Manual procedure that involves a d…
    #> 2 9       5     Approach  X     External     Procedures performed directly on t…
    #> 
    #> $includes
    #> [1] NA

``` r
pcs("B00B0ZZ") # Imaging
```

    #> $code
    #> [1] "B00B0ZZ"
    #> 
    #> $description
    #> [1] "Plain Radiography of Spinal Cord using High Osmolar Contrast"
    #> 
    #> $axes
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
    #> 
    #> $definitions
    #> [1] NA
    #> 
    #> $includes
    #> [1] NA

``` r
pcs("C0101ZZ") # Nuclear Medicine
```

    #> $code
    #> [1] "C0101ZZ"
    #> 
    #> $description
    #> [1] "Planar Nuclear Medicine Imaging of Brain using Technetium 99m (Tc-99m)"
    #> 
    #> $axes
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
    #> 
    #> $definitions
    #> [1] NA
    #> 
    #> $includes
    #> [1] NA

``` r
pcs("DG22DZZ") # Radiation Therapy
```

    #> $code
    #> [1] "DG22DZZ"
    #> 
    #> $description
    #> [1] "Stereotactic Other Photon Radiosurgery of Adrenal Glands"
    #> 
    #> $axes
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
    #> 
    #> $definitions
    #> [1] NA
    #> 
    #> $includes
    #> [1] NA

``` r
pcs("F14Z01Z") # Physical Rehabilitation and Diagnostic Audiology
```

    #> $code
    #> [1] "F14Z01Z"
    #> 
    #> $description
    #> [1] "Cochlear Implant Assessment using Audiometer"
    #> 
    #> $axes
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
    #> 
    #> $definitions
    #> # A tibble: 10 × 6
    #>    section axis  name           value label                           definition
    #>    <chr>   <chr> <chr>          <chr> <chr>                           <chr>     
    #>  1 F       3     Type           4     Hearing Aid Assessment          Measureme…
    #>  2 F       5     Type Qualifier 0     Bathing/Showering Techniques    Activitie…
    #>  3 F       5     Type Qualifier 0     Bithermal, Binaural Caloric Ir… Measures …
    #>  4 F       5     Type Qualifier 0     Cochlear Implant                Measures …
    #>  5 F       5     Type Qualifier 0     Cochlear Implant Rehabilitation Applying …
    #>  6 F       5     Type Qualifier 0     Filtered Speech                 Uses high…
    #>  7 F       5     Type Qualifier 0     Hearing and Related Disorders … Provides …
    #>  8 F       5     Type Qualifier 0     Hearing Screening               Pass/refe…
    #>  9 F       5     Type Qualifier 0     Range of Motion and Joint Mobi… Exercise …
    #> 10 F       5     Type Qualifier 0     Vestibular                      Applying …
    #> 
    #> $includes
    #> [1] NA

``` r
pcs("GZ10ZZZ") # Mental Health
```

    #> $code
    #> [1] "GZ10ZZZ"
    #> 
    #> $description
    #> [1] "Psychological Tests, Developmental"
    #> 
    #> $axes
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
    #> 
    #> $definitions
    #> [1] NA
    #> 
    #> $includes
    #> [1] NA

``` r
pcs("HZ96ZZZ") # Substance Abuse Treatment
```

    #> $code
    #> [1] "HZ96ZZZ"
    #> 
    #> $description
    #> [1] "Pharmacotherapy for Substance Abuse Treatment, Clonidine"
    #> 
    #> $axes
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
    #> 
    #> $definitions
    #> [1] NA
    #> 
    #> $includes
    #> [1] NA

``` r
pcs("XY0YX37") # New Technology
```

    #> $code
    #> [1] "XY0YX37"
    #> 
    #> $description
    #> [1] "Extracorporeal Introduction of Nafamostat Anticoagulant, New Technology Group 7"
    #> 
    #> $axes
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
    #> 
    #> $definitions
    #> # A tibble: 2 × 6
    #>   section axis  name      value label        definition                         
    #>   <chr>   <chr> <chr>     <chr> <chr>        <chr>                              
    #> 1 X       3     Operation 0     Introduction Putting in or on a therapeutic, di…
    #> 2 X       5     Approach  X     External     Procedures performed directly on t…
    #> 
    #> $includes
    #> [1] NA

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
