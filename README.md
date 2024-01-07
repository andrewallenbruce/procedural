
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

## Tables

``` r
tables("0")
```

    #> # A tibble: 601 × 5
    #>    section system table description                                   codes     
    #>    <chr>   <chr>  <chr> <chr>                                         <list>    
    #>  1 0       00     001   Medical and Surgical, Central Nervous System… <spc_tbl_>
    #>  2 0       00     002   Medical and Surgical, Central Nervous System… <spc_tbl_>
    #>  3 0       00     005   Medical and Surgical, Central Nervous System… <spc_tbl_>
    #>  4 0       00     007   Medical and Surgical, Central Nervous System… <spc_tbl_>
    #>  5 0       00     008   Medical and Surgical, Central Nervous System… <spc_tbl_>
    #>  6 0       00     009   Medical and Surgical, Central Nervous System… <spc_tbl_>
    #>  7 0       00     00B   Medical and Surgical, Central Nervous System… <spc_tbl_>
    #>  8 0       00     00C   Medical and Surgical, Central Nervous System… <spc_tbl_>
    #>  9 0       00     00D   Medical and Surgical, Central Nervous System… <spc_tbl_>
    #> 10 0       00     00F   Medical and Surgical, Central Nervous System… <spc_tbl_>
    #> # ℹ 591 more rows

``` r
tables("00")
```

    #> # A tibble: 22 × 5
    #>    section system table description                                   codes     
    #>    <chr>   <chr>  <chr> <chr>                                         <list>    
    #>  1 0       00     001   Medical and Surgical, Central Nervous System… <spc_tbl_>
    #>  2 0       00     002   Medical and Surgical, Central Nervous System… <spc_tbl_>
    #>  3 0       00     005   Medical and Surgical, Central Nervous System… <spc_tbl_>
    #>  4 0       00     007   Medical and Surgical, Central Nervous System… <spc_tbl_>
    #>  5 0       00     008   Medical and Surgical, Central Nervous System… <spc_tbl_>
    #>  6 0       00     009   Medical and Surgical, Central Nervous System… <spc_tbl_>
    #>  7 0       00     00B   Medical and Surgical, Central Nervous System… <spc_tbl_>
    #>  8 0       00     00C   Medical and Surgical, Central Nervous System… <spc_tbl_>
    #>  9 0       00     00D   Medical and Surgical, Central Nervous System… <spc_tbl_>
    #> 10 0       00     00F   Medical and Surgical, Central Nervous System… <spc_tbl_>
    #> # ℹ 12 more rows

``` r
tables("00F")$codes
```

    #> [[1]]
    #> # A tibble: 20 × 2
    #>    code    label                                                                
    #>    <chr>   <chr>                                                                
    #>  1 00F30ZZ Fragmentation in Intracranial Epidural Space, Open Approach          
    #>  2 00F33ZZ Fragmentation in Intracranial Epidural Space, Percutaneous Approach  
    #>  3 00F34ZZ Fragmentation in Intracranial Epidural Space, Percutaneous Endoscopi…
    #>  4 00F3XZZ Fragmentation in Intracranial Epidural Space, External Approach      
    #>  5 00F40ZZ Fragmentation in Intracranial Subdural Space, Open Approach          
    #>  6 00F43ZZ Fragmentation in Intracranial Subdural Space, Percutaneous Approach  
    #>  7 00F44ZZ Fragmentation in Intracranial Subdural Space, Percutaneous Endoscopi…
    #>  8 00F4XZZ Fragmentation in Intracranial Subdural Space, External Approach      
    #>  9 00F50ZZ Fragmentation in Intracranial Subarachnoid Space, Open Approach      
    #> 10 00F53ZZ Fragmentation in Intracranial Subarachnoid Space, Percutaneous Appro…
    #> 11 00F54ZZ Fragmentation in Intracranial Subarachnoid Space, Percutaneous Endos…
    #> 12 00F5XZZ Fragmentation in Intracranial Subarachnoid Space, External Approach  
    #> 13 00F60ZZ Fragmentation in Cerebral Ventricle, Open Approach                   
    #> 14 00F63ZZ Fragmentation in Cerebral Ventricle, Percutaneous Approach           
    #> 15 00F64ZZ Fragmentation in Cerebral Ventricle, Percutaneous Endoscopic Approach
    #> 16 00F6XZZ Fragmentation in Cerebral Ventricle, External Approach               
    #> 17 00FU0ZZ Fragmentation in Spinal Canal, Open Approach                         
    #> 18 00FU3ZZ Fragmentation in Spinal Canal, Percutaneous Approach                 
    #> 19 00FU4ZZ Fragmentation in Spinal Canal, Percutaneous Endoscopic Approach      
    #> 20 00FUXZZ Fragmentation in Spinal Canal, External Approach

## Definitions

``` r
definitions()
```

    #> # A tibble: 917 × 9
    #>    code  section axis  axis_name axis_code label definition explanation includes
    #>    <chr> <chr>   <chr> <chr>     <chr>     <chr> <chr>      <chr>       <chr>   
    #>  1 0     Medica… 3     Operation 0         Alte… Modifying… Principal … Face li…
    #>  2 0     Medica… 3     Operation 1         Bypa… Altering … Rerouting … Coronar…
    #>  3 0     Medica… 3     Operation 2         Chan… Taking ou… All CHANGE… Urinary…
    #>  4 0     Medica… 3     Operation 3         Cont… Stopping,… <NA>        Control…
    #>  5 0     Medica… 3     Operation 4         Crea… Putting i… Used for g… Creatio…
    #>  6 0     Medica… 3     Operation 5         Dest… Physical … None of th… Fulgura…
    #>  7 0     Medica… 3     Operation 6         Deta… Cutting o… The body p… Below k…
    #>  8 0     Medica… 3     Operation 7         Dila… Expanding… The orific… Percuta…
    #>  9 0     Medica… 3     Operation 8         Divi… Cutting i… All or a p… Spinal …
    #> 10 0     Medica… 3     Operation 9         Drai… Taking or… The qualif… Thorace…
    #> # ℹ 907 more rows

## `pcs()`

``` r
pcs("0G9000Z") # Medical and Surgical
```

    #> # A tibble: 7 × 5
    #>   axis  name        code  label                table  
    #>   <chr> <chr>       <chr> <chr>                <glue> 
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
    #>   <chr> <chr>       <chr> <chr>                           <glue> 
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
    #>   <chr> <chr>       <chr> <chr>              <glue> 
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
    #>   <chr> <chr>                <chr> <chr>                                   <glu>
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
    #>   <chr> <chr>             <chr> <chr>                      <glue> 
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
    #>   <chr> <chr>       <chr> <chr>                                            <glu>
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
    #>   <chr> <chr>       <chr> <chr>                                <glue> 
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
    #>   <chr> <chr>       <chr> <chr>                <glue> 
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
    #>   <chr> <chr>       <chr> <chr>               <glue> 
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
    #>   <chr> <chr>       <chr> <chr>              <glue> 
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
    #>   <chr> <chr>       <chr> <chr>                  <glue> 
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
    #>   <chr> <chr>        <chr> <chr>                           <glue> 
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
    #>   <chr> <chr>              <chr> <chr>                                  <glue> 
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
    #>   <chr> <chr>                <chr> <chr>                                   <glu>
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
    #>   <chr> <chr>       <chr> <chr>               <glue> 
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
    #>   <chr> <chr>       <chr> <chr>                     <glue> 
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
    #>   <chr> <chr>                           <chr> <chr>                    <glue> 
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
