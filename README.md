
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
    #> # A tibble: 0 × 5
    #> # ℹ 5 variables: section <chr>, axis <chr>, name <chr>, label <chr>,
    #> #   includes <chr>

## Codes

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
    #> # A tibble: 2 × 5
    #>   section axis  name      label           includes                              
    #>   <chr>   <chr> <chr>     <chr>           <chr>                                 
    #> 1 0       4     Body Part Pituitary Gland Adenohypophysis, Hypophysis, Neurohyp…
    #> 2 0       6     Device    Drainage Device Cystostomy tube, Foley catheter, Perc…

``` r
pcs("10D20ZZ") # Obstetrics
```

    #> Error in UseMethod("nest"): no applicable method for 'nest' applied to an object of class "logical"

``` r
pcs("2W0UX0Z") # Placement
```

    #> Error in UseMethod("nest"): no applicable method for 'nest' applied to an object of class "logical"

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
    #> # A tibble: 0 × 5
    #> # ℹ 5 variables: section <chr>, axis <chr>, name <chr>, label <chr>,
    #> #   includes <chr>

``` r
pcs("4B01XVZ") # Measurement and Monitoring
```

    #> Error in UseMethod("nest"): no applicable method for 'nest' applied to an object of class "logical"

``` r
pcs("5A02110") # Extracorporeal or Systemic Assistance and Performance
```

    #> Error in UseMethod("nest"): no applicable method for 'nest' applied to an object of class "logical"

``` r
pcs("6A0Z0ZZ") # Extracorporeal or Systemic Therapies
```

    #> Error in UseMethod("nest"): no applicable method for 'nest' applied to an object of class "logical"

``` r
pcs("7W00X0Z") # Osteopathic
```

    #> Error in UseMethod("nest"): no applicable method for 'nest' applied to an object of class "logical"

``` r
pcs("8C01X6J") # Other Procedures
```

    #> Error in UseMethod("nest"): no applicable method for 'nest' applied to an object of class "logical"

``` r
pcs("9WB0XBZ") # Chiropractic
```

    #> Error in UseMethod("nest"): no applicable method for 'nest' applied to an object of class "logical"

``` r
pcs("B00B0ZZ") # Imaging
```

    #> Error in UseMethod("nest"): no applicable method for 'nest' applied to an object of class "logical"

``` r
pcs("C0101ZZ") # Nuclear Medicine
```

    #> Error in UseMethod("nest"): no applicable method for 'nest' applied to an object of class "logical"

``` r
pcs("DG22DZZ") # Radiation Therapy
```

    #> Error in `definitions()`:
    #> ! `section` must be one of "0", "1", "2", "3", "4", "5", "6", "7", "8",
    #>   "9", "B", "C", "F", "G", "H", or "X", not "D".

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
    #> # A tibble: 0 × 5
    #> # ℹ 5 variables: section <chr>, axis <chr>, name <chr>, label <chr>,
    #> #   includes <chr>

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
    #> # A tibble: 1 × 6
    #>   section axis  name  value label               definition                      
    #>   <chr>   <chr> <chr> <chr> <chr>               <chr>                           
    #> 1 G       3     Type  1     Psychological Tests The administration and interpre…
    #> 
    #> $includes
    #> # A tibble: 0 × 5
    #> # ℹ 5 variables: section <chr>, axis <chr>, name <chr>, label <chr>,
    #> #   includes <chr>

``` r
pcs("HZ96ZZZ") # Substance Abuse Treatment
```

    #> Error in UseMethod("nest"): no applicable method for 'nest' applied to an object of class "logical"

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
    #> # A tibble: 1 × 5
    #>   section axis  name                            label                   includes
    #>   <chr>   <chr> <chr>                           <chr>                   <chr>   
    #> 1 X       6     Device / Substance / Technology Nafamostat Anticoagula… LTX Reg…

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
