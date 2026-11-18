# ICD-10-PCS Index

ICD-10-PCS Index

## Usage

``` r
index(term = NULL)
```

## Arguments

- term:

  `<chr>` term to search for

## Value

a [tibble::tibble](https://tibble.tidyverse.org/reference/tibble.html)
containing the results

## Examples

``` r
index()
#> # A tibble: 61,866 × 6
#>    entry letter term                            field     value           source
#>    <int> <chr>  <chr>                           <chr>     <chr>           <chr> 
#>  1     1 3      3f (Aortic) Bioprosthesis valve use       Zooplastic Tis… mainT…
#>  2     2 3      3M(tm) V.A.C.(R) Therapy System see       Activities of … mainT…
#>  3     2 3      3M(tm) V.A.C.(R) Therapy System see/tab   F08             mainT…
#>  4     3 A      Abdominal aortic plexus         use       Abdominal Symp… mainT…
#>  5     4 A      Abdominal cavity                use       Peritoneal Cav… mainT…
#>  6     5 A      Abdominal esophagus             use       Esophagus, Low… mainT…
#>  7     6 A      Abdominohysterectomy            see       Resection, Ute… mainT…
#>  8     6 A      Abdominohysterectomy            see/codes 0UT9            mainT…
#>  9     7 A      Abdominoplasty                  level     1               mainT…
#> 10     7 A      Abdominoplasty                  see       Alteration, Ab… mainT…
#> # ℹ 61,856 more rows
# index(term = "Abdominohysterectomy")
# index(term = "Attain Ability")
# index(term = "radi*")
```
