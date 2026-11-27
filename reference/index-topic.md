# Search the PCS Alphabetic Index

The Alphabetic Index maps clinician-documented terminology to PCS tables
and codes.

## Usage

``` r
index(letter = NULL, term = NULL)
```

## Arguments

- letter:

  `<chr>` letter/chapter to filter to; A - Z, including 3

- term:

  `<chr>` term to search for

## Value

a [tibble::tibble](https://tibble.tidyverse.org/reference/tibble.html)
containing the results

## Details

Unlike the ICD-10-CM index, most entries do not end at a complete code.
Rather, they point to a PCS table or row (the first three or four
characters), and the coder completes the remaining characters inside
that table. Look up the term, follow it to the table, then build and
verify the full seven-character code on its code page.

## Examples

``` r
index(term = "Abdominohysterectomy")
#> # A tibble: 2 × 6
#>   entry letter term                 field     value             source          
#>   <int> <chr>  <chr>                <chr>     <chr>             <chr>           
#> 1     6 A      Abdominohysterectomy see       Resection, Uterus mainTerm/see    
#> 2     6 A      Abdominohysterectomy see/codes 0UT9              mainTerm/see/co…
index(term = "Attain Ability")
#> # A tibble: 6 × 6
#>   entry letter term                   field   value                       source
#>   <int> <chr>  <chr>                  <chr>   <chr>                       <chr> 
#> 1   236 A      Attain Ability(R) lead level   1                           mainT…
#> 2   236 A      Attain Ability(R) lead use     Cardiac Lead, Pacemaker in  mainT…
#> 3   236 A      Attain Ability(R) lead use/tab 02H                         mainT…
#> 4   236 A      Attain Ability(R) lead level   1                           mainT…
#> 5   236 A      Attain Ability(R) lead use     Cardiac Lead, Defibrillato… mainT…
#> 6   236 A      Attain Ability(R) lead use/tab 02H                         mainT…
index(term = "arthr*")
#> # A tibble: 95 × 6
#>    entry letter term        field   value                   source              
#>    <int> <chr>  <chr>       <chr>   <chr>                   <chr>               
#>  1   194 A      Arthrectomy level   1                       mainTerm/term/@level
#>  2   194 A      Arthrectomy see     Excision, Upper Joints  mainTerm/term/see   
#>  3   194 A      Arthrectomy see/tab 0RB                     mainTerm/term/see/t…
#>  4   194 A      Arthrectomy level   1                       mainTerm/term/@level
#>  5   194 A      Arthrectomy see     Resection, Upper Joints mainTerm/term/see   
#>  6   194 A      Arthrectomy see/tab 0RT                     mainTerm/term/see/t…
#>  7   194 A      Arthrectomy level   1                       mainTerm/term/@level
#>  8   194 A      Arthrectomy see     Excision, Lower Joints  mainTerm/term/see   
#>  9   194 A      Arthrectomy see/tab 0SB                     mainTerm/term/see/t…
#> 10   194 A      Arthrectomy level   1                       mainTerm/term/@level
#> # ℹ 85 more rows
index(letter = "3")
#> # A tibble: 3 × 6
#>   entry letter term                            field   value              source
#>   <int> <chr>  <chr>                           <chr>   <chr>              <chr> 
#> 1     1 3      3f (Aortic) Bioprosthesis valve use     Zooplastic Tissue… mainT…
#> 2     2 3      3M(tm) V.A.C.(R) Therapy System see     Activities of Dai… mainT…
#> 3     2 3      3M(tm) V.A.C.(R) Therapy System see/tab F08                mainT…
```
