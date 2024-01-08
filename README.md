
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

    #> # A tibble: 1 × 5
    #>   letter term           verb  pcs_value       table
    #>   <chr>  <chr>          <chr> <chr>           <chr>
    #> 1 A      Achillorrhaphy See   Repair, Tendons 0LQ

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

    #> # A tibble: 28 × 6
    #>    table row   description                                 rowid axes     n_axes
    #>    <chr> <chr> <chr>                                       <int> <list>    <int>
    #>  1 0LQ   0LQ0  Body Part, Head and Neck Tendon               983 <tibble>      5
    #>  2 0LQ   0LQ1  Body Part, Shoulder Tendon, Right             983 <tibble>      5
    #>  3 0LQ   0LQ2  Body Part, Shoulder Tendon, Left              983 <tibble>      5
    #>  4 0LQ   0LQ3  Body Part, Upper Arm Tendon, Right            983 <tibble>      5
    #>  5 0LQ   0LQ4  Body Part, Upper Arm Tendon, Left             983 <tibble>      5
    #>  6 0LQ   0LQ5  Body Part, Lower Arm and Wrist Tendon, Rig…   983 <tibble>      5
    #>  7 0LQ   0LQ6  Body Part, Lower Arm and Wrist Tendon, Left   983 <tibble>      5
    #>  8 0LQ   0LQ7  Body Part, Hand Tendon, Right                 983 <tibble>      5
    #>  9 0LQ   0LQ8  Body Part, Hand Tendon, Left                  983 <tibble>      5
    #> 10 0LQ   0LQ9  Body Part, Trunk Tendon, Right                983 <tibble>      5
    #> # ℹ 18 more rows

``` r
rows("0LQ0")
```

    #> # A tibble: 1 × 6
    #>   table row   description                     rowid axes             n_axes
    #>   <chr> <chr> <chr>                           <int> <list>            <int>
    #> 1 0LQ   0LQ0  Body Part, Head and Neck Tendon   983 <tibble [5 × 4]>      5

``` r
rows("0LQ0")$axes
```

    #> [[1]]
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
definitions(section = "0", axis = "5") |> 
  dplyr::filter(axis_code %in% c("0", "3", "4")) |> 
  dplyr::select(label, definition)
```

    #> # A tibble: 3 × 2
    #>   label                   definition                                            
    #>   <chr>                   <chr>                                                 
    #> 1 Open                    Cutting through the skin or mucous membrane and any o…
    #> 2 Percutaneous            Entry, by puncture or minor incision, of instrumentat…
    #> 3 Percutaneous Endoscopic Entry, by puncture or minor incision, of instrumentat…

``` r
pcs("0LQV3ZZ")
```

    #> # A tibble: 7 × 5
    #>   axis  name        code  label                table  
    #>   <chr> <chr>       <chr> <chr>                <chr>  
    #> 1 1     Section     0     Medical and Surgical 0      
    #> 2 2     Body System L     Tendons              0L     
    #> 3 3     Operation   Q     Repair               0LQ    
    #> 4 4     Body Part   V     Foot Tendon, Right   0LQV   
    #> 5 5     Approach    3     Percutaneous         0LQV3  
    #> 6 6     Device      Z     No Device            0LQV3Z 
    #> 7 7     Qualifier   Z     No Qualifier         0LQV3ZZ

## Codes

``` r
pcs("0G9000Z") # Medical and Surgical
```

    #> # A tibble: 7 × 5
    #>   axis  name        code  label                table  
    #>   <chr> <chr>       <chr> <chr>                <chr>  
    #> 1 1     Section     0     Medical and Surgical 0      
    #> 2 2     Body System G     Endocrine System     0G     
    #> 3 3     Operation   9     Drainage             0G9    
    #> 4 4     Body Part   0     Pituitary Gland      0G90   
    #> 5 5     Approach    0     Open                 0G900  
    #> 6 6     Device      0     Drainage Device      0G9000 
    #> 7 7     Qualifier   Z     No Qualifier         0G9000Z

``` r
pcs("10D20ZZ") # Obstetrics
```

    #> # A tibble: 7 × 5
    #>   axis  name        code  label                           table  
    #>   <chr> <chr>       <chr> <chr>                           <chr>  
    #> 1 1     Section     1     Obstetrics                      1      
    #> 2 2     Body System 0     Pregnancy                       10     
    #> 3 3     Operation   D     Extraction                      10D    
    #> 4 4     Body Part   2     Products of Conception, Ectopic 10D2   
    #> 5 5     Approach    0     Open                            10D20  
    #> 6 6     Device      Z     No Device                       10D20Z 
    #> 7 7     Qualifier   Z     No Qualifier                    10D20ZZ

``` r
pcs("2W0UX0Z") # Placement
```

    #> # A tibble: 7 × 5
    #>   axis  name        code  label              table  
    #>   <chr> <chr>       <chr> <chr>              <chr>  
    #> 1 1     Section     2     Placement          2      
    #> 2 2     Body System W     Anatomical Regions 2W     
    #> 3 3     Operation   0     Change             2W0    
    #> 4 4     Body Region U     Toe, Right         2W0U   
    #> 5 5     Approach    X     External           2W0UX  
    #> 6 6     Device      0     Traction Apparatus 2W0UX0 
    #> 7 7     Qualifier   Z     No Qualifier       2W0UX0Z

``` r
pcs("3E1938X") # Administration
```

    #> # A tibble: 7 × 5
    #>   axis  name                 code  label                                   table
    #>   <chr> <chr>                <chr> <chr>                                   <chr>
    #> 1 1     Section              3     Administration                          3    
    #> 2 2     Body System          E     Physiological Systems and Anatomical R… 3E   
    #> 3 3     Operation            1     Irrigation                              3E1  
    #> 4 4     Body System / Region 9     Nose                                    3E19 
    #> 5 5     Approach             3     Percutaneous                            3E193
    #> 6 6     Substance            8     Irrigating Substance                    3E19…
    #> 7 7     Qualifier            X     Diagnostic                              3E19…

``` r
pcs("4B01XVZ") # Measurement and Monitoring
```

    #> # A tibble: 7 × 5
    #>   axis  name              code  label                      table  
    #>   <chr> <chr>             <chr> <chr>                      <chr>  
    #> 1 1     Section           4     Measurement and Monitoring 4      
    #> 2 2     Body System       B     Physiological Devices      4B     
    #> 3 3     Operation         0     Measurement                4B0    
    #> 4 4     Body System       1     Peripheral Nervous         4B01   
    #> 5 5     Approach          X     External                   4B01X  
    #> 6 6     Function / Device V     Stimulator                 4B01XV 
    #> 7 7     Qualifier         Z     No Qualifier               4B01XVZ

``` r
pcs("5A02110") # Extracorporeal or Systemic Assistance and Performance
```

    #> # A tibble: 7 × 5
    #>   axis  name        code  label                                            table
    #>   <chr> <chr>       <chr> <chr>                                            <chr>
    #> 1 1     Section     5     Extracorporeal or Systemic Assistance and Perfo… 5    
    #> 2 2     Body System A     Physiological Systems                            5A   
    #> 3 3     Operation   0     Assistance                                       5A0  
    #> 4 4     Body System 2     Cardiac                                          5A02 
    #> 5 5     Duration    1     Intermittent                                     5A021
    #> 6 6     Function    1     Output                                           5A02…
    #> 7 7     Qualifier   0     Balloon Pump                                     5A02…

``` r
pcs("6A0Z0ZZ") # Extracorporeal or Systemic Therapies
```

    #> # A tibble: 7 × 5
    #>   axis  name        code  label                                table  
    #>   <chr> <chr>       <chr> <chr>                                <chr>  
    #> 1 1     Section     6     Extracorporeal or Systemic Therapies 6      
    #> 2 2     Body System A     Physiological Systems                6A     
    #> 3 3     Operation   0     Atmospheric Control                  6A0    
    #> 4 4     Body System Z     None                                 6A0Z   
    #> 5 5     Duration    0     Single                               6A0Z0  
    #> 6 6     Qualifier   Z     No Qualifier                         6A0Z0Z 
    #> 7 7     Qualifier   Z     No Qualifier                         6A0Z0ZZ

``` r
pcs("7W00X0Z") # Osteopathic
```

    #> # A tibble: 7 × 5
    #>   axis  name        code  label                table  
    #>   <chr> <chr>       <chr> <chr>                <chr>  
    #> 1 1     Section     7     Osteopathic          7      
    #> 2 2     Body System W     Anatomical Regions   7W     
    #> 3 3     Operation   0     Treatment            7W0    
    #> 4 4     Body Region 0     Head                 7W00   
    #> 5 5     Approach    X     External             7W00X  
    #> 6 6     Method      0     Articulatory-Raising 7W00X0 
    #> 7 7     Qualifier   Z     None                 7W00X0Z

``` r
pcs("8C01X6J") # Other Procedures
```

    #> # A tibble: 7 × 5
    #>   axis  name        code  label               table  
    #>   <chr> <chr>       <chr> <chr>               <chr>  
    #> 1 1     Section     8     Other Procedures    8      
    #> 2 2     Body System C     Indwelling Device   8C     
    #> 3 3     Operation   0     Other Procedures    8C0    
    #> 4 4     Body Region 1     Nervous System      8C01   
    #> 5 5     Approach    X     External            8C01X  
    #> 6 6     Method      6     Collection          8C01X6 
    #> 7 7     Qualifier   J     Cerebrospinal Fluid 8C01X6J

``` r
pcs("9WB0XBZ") # Chiropractic
```

    #> # A tibble: 7 × 5
    #>   axis  name        code  label              table  
    #>   <chr> <chr>       <chr> <chr>              <chr>  
    #> 1 1     Section     9     Chiropractic       9      
    #> 2 2     Body System W     Anatomical Regions 9W     
    #> 3 3     Operation   B     Manipulation       9WB    
    #> 4 4     Body Region 0     Head               9WB0   
    #> 5 5     Approach    X     External           9WB0X  
    #> 6 6     Method      B     Non-Manual         9WB0XB 
    #> 7 7     Qualifier   Z     None               9WB0XBZ

``` r
pcs("B00B0ZZ") # Imaging
```

    #> # A tibble: 7 × 5
    #>   axis  name        code  label                  table  
    #>   <chr> <chr>       <chr> <chr>                  <chr>  
    #> 1 1     Section     B     Imaging                B      
    #> 2 2     Body System 0     Central Nervous System B0     
    #> 3 3     Type        0     Plain Radiography      B00    
    #> 4 4     Body Part   B     Spinal Cord            B00B   
    #> 5 5     Contrast    0     High Osmolar           B00B0  
    #> 6 6     Qualifier   Z     None                   B00B0Z 
    #> 7 7     Qualifier   Z     None                   B00B0ZZ

``` r
pcs("C0101ZZ") # Nuclear Medicine
```

    #> # A tibble: 7 × 5
    #>   axis  name         code  label                           table  
    #>   <chr> <chr>        <chr> <chr>                           <chr>  
    #> 1 1     Section      C     Nuclear Medicine                C      
    #> 2 2     Body System  0     Central Nervous System          C0     
    #> 3 3     Type         1     Planar Nuclear Medicine Imaging C01    
    #> 4 4     Body Part    0     Brain                           C010   
    #> 5 5     Radionuclide 1     Technetium 99m (Tc-99m)         C0101  
    #> 6 6     Qualifier    Z     None                            C0101Z 
    #> 7 7     Qualifier    Z     None                            C0101ZZ

``` r
pcs("DG22DZZ") # Radiation Therapy
```

    #> # A tibble: 7 × 5
    #>   axis  name               code  label                                  table  
    #>   <chr> <chr>              <chr> <chr>                                  <chr>  
    #> 1 1     Section            D     Radiation Therapy                      D      
    #> 2 2     Body System        G     Endocrine System                       DG     
    #> 3 3     Modality           2     Stereotactic Radiosurgery              DG2    
    #> 4 4     Treatment Site     2     Adrenal Glands                         DG22   
    #> 5 5     Modality Qualifier D     Stereotactic Other Photon Radiosurgery DG22D  
    #> 6 6     Isotope            Z     None                                   DG22DZ 
    #> 7 7     Qualifier          Z     None                                   DG22DZZ

``` r
pcs("F14Z01Z") # Physical Rehabilitation and Diagnostic Audiology
```

    #> # A tibble: 7 × 5
    #>   axis  name                 code  label                                   table
    #>   <chr> <chr>                <chr> <chr>                                   <chr>
    #> 1 1     Section              F     Physical Rehabilitation and Diagnostic… F    
    #> 2 2     Section Qualifier    1     Diagnostic Audiology                    F1   
    #> 3 3     Type                 4     Hearing Aid Assessment                  F14  
    #> 4 4     Body System / Region Z     None                                    F14Z 
    #> 5 5     Type Qualifier       0     Cochlear Implant                        F14Z0
    #> 6 6     Equipment            1     Audiometer                              F14Z…
    #> 7 7     Qualifier            Z     None                                    F14Z…

``` r
pcs("GZ10ZZZ") # Mental Health
```

    #> # A tibble: 7 × 5
    #>   axis  name        code  label               table  
    #>   <chr> <chr>       <chr> <chr>               <chr>  
    #> 1 1     Section     G     Mental Health       G      
    #> 2 2     Body System Z     None                GZ     
    #> 3 3     Type        1     Psychological Tests GZ1    
    #> 4 4     Qualifier   0     Developmental       GZ10   
    #> 5 5     Qualifier   Z     None                GZ10Z  
    #> 6 6     Qualifier   Z     None                GZ10ZZ 
    #> 7 7     Qualifier   Z     None                GZ10ZZZ

``` r
pcs("HZ96ZZZ") # Substance Abuse Treatment
```

    #> # A tibble: 7 × 5
    #>   axis  name        code  label                     table  
    #>   <chr> <chr>       <chr> <chr>                     <chr>  
    #> 1 1     Section     H     Substance Abuse Treatment H      
    #> 2 2     Body System Z     None                      HZ     
    #> 3 3     Type        9     Pharmacotherapy           HZ9    
    #> 4 4     Qualifier   6     Clonidine                 HZ96   
    #> 5 5     Qualifier   Z     None                      HZ96Z  
    #> 6 6     Qualifier   Z     None                      HZ96ZZ 
    #> 7 7     Qualifier   Z     None                      HZ96ZZZ

``` r
pcs("XY0YX37") # New Technology
```

    #> # A tibble: 7 × 5
    #>   axis  name                            code  label                    table  
    #>   <chr> <chr>                           <chr> <chr>                    <chr>  
    #> 1 1     Section                         X     New Technology           X      
    #> 2 2     Body System                     Y     Extracorporeal           XY     
    #> 3 3     Operation                       0     Introduction             XY0    
    #> 4 4     Body Part                       Y     Extracorporeal           XY0Y   
    #> 5 5     Approach                        X     External                 XY0YX  
    #> 6 6     Device / Substance / Technology 3     Nafamostat Anticoagulant XY0YX3 
    #> 7 7     Qualifier                       7     New Technology Group 7   XY0YX37

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
