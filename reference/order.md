# PCS Code Order/Range

PCS Code Order/Range

## Usage

``` r
order(x)

range(start, end)
```

## Arguments

- x:

  description

- start, end:

  `<chr>` Full 7-character ICD-10-PCS code.

## Value

a [tibble::tibble](https://tibble.tidyverse.org/reference/tibble.html)
containing the results

## Examples

``` r
order()
#> # A data frame: 80,174 × 4
#>    order valid code    description                                              
#>    <int> <int> <chr>   <chr>                                                    
#>  1     1     0 001     Central Nervous System and Cranial Nerves, Bypass        
#>  2     2     1 0016070 Bypass Cerebral Ventricle to Nasopharynx with Autologous…
#>  3     3     1 0016071 Bypass Cerebral Ventricle to Mastoid Sinus with Autologo…
#>  4     4     1 0016072 Bypass Cerebral Ventricle to Atrium with Autologous Tiss…
#>  5     5     1 0016073 Bypass Cerebral Ventricle to Blood Vessel with Autologou…
#>  6     6     1 0016074 Bypass Cerebral Ventricle to Pleural Cavity with Autolog…
#>  7     7     1 0016075 Bypass Cerebral Ventricle to Intestine with Autologous T…
#>  8     8     1 0016076 Bypass Cerebral Ventricle to Peritoneal Cavity with Auto…
#>  9     9     1 0016077 Bypass Cerebral Ventricle to Urinary Tract with Autologo…
#> 10    10     1 0016078 Bypass Cerebral Ventricle to Bone Marrow with Autologous…
#> # ℹ 80,164 more rows

range("0G9000Z", "0G9100Z")
#> # A data frame: 10 × 4
#>    order valid code    description                                              
#>    <int> <int> <chr>   <chr>                                                    
#>  1 35883     1 0G9000Z Drainage of Pituitary Gland with Drainage Device, Open A…
#>  2 35884     1 0G900ZX Drainage of Pituitary Gland, Open Approach, Diagnostic   
#>  3 35885     1 0G900ZZ Drainage of Pituitary Gland, Open Approach               
#>  4 35886     1 0G9030Z Drainage of Pituitary Gland with Drainage Device, Percut…
#>  5 35887     1 0G903ZX Drainage of Pituitary Gland, Percutaneous Approach, Diag…
#>  6 35888     1 0G903ZZ Drainage of Pituitary Gland, Percutaneous Approach       
#>  7 35889     1 0G9040Z Drainage of Pituitary Gland with Drainage Device, Percut…
#>  8 35890     1 0G904ZX Drainage of Pituitary Gland, Percutaneous Endoscopic App…
#>  9 35891     1 0G904ZZ Drainage of Pituitary Gland, Percutaneous Endoscopic App…
#> 10 35892     1 0G9100Z Drainage of Pineal Body with Drainage Device, Open Appro…
range("0G9000Z", "10D20ZZ")
#> # A data frame: 33,276 × 4
#>    order valid code    description                                              
#>    <int> <int> <chr>   <chr>                                                    
#>  1 35883     1 0G9000Z Drainage of Pituitary Gland with Drainage Device, Open A…
#>  2 35884     1 0G900ZX Drainage of Pituitary Gland, Open Approach, Diagnostic   
#>  3 35885     1 0G900ZZ Drainage of Pituitary Gland, Open Approach               
#>  4 35886     1 0G9030Z Drainage of Pituitary Gland with Drainage Device, Percut…
#>  5 35887     1 0G903ZX Drainage of Pituitary Gland, Percutaneous Approach, Diag…
#>  6 35888     1 0G903ZZ Drainage of Pituitary Gland, Percutaneous Approach       
#>  7 35889     1 0G9040Z Drainage of Pituitary Gland with Drainage Device, Percut…
#>  8 35890     1 0G904ZX Drainage of Pituitary Gland, Percutaneous Endoscopic App…
#>  9 35891     1 0G904ZZ Drainage of Pituitary Gland, Percutaneous Endoscopic App…
#> 10 35892     1 0G9100Z Drainage of Pineal Body with Drainage Device, Open Appro…
#> # ℹ 33,266 more rows
range("0G9000Z", "0G9000Z")
#> # A data frame: 1 × 4
#>   order valid code    description                                               
#>   <int> <int> <chr>   <chr>                                                     
#> 1 35883     1 0G9000Z Drainage of Pituitary Gland with Drainage Device, Open Ap…
try(range("0G9100Z", "0G9000Z"))
#> Error in range("0G9100Z", "0G9000Z") : 
#>   ✖ 0G9100Z (#35892) comes after 0G9000Z (#35883)
#> ℹ Did you mean `p_range(start = "0G9000Z", end = "0G9100Z")` ?
```
