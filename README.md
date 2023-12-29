
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
library(dplyr)
library(gt)
```

## Sections

``` r
section()[c('code', 'label')] |> 
  gt() |> 
  opt_table_font(font = google_font(name = "Rubik")) |> 
  cols_align(align = "center", columns = code) |>
  tab_style(style = list(cell_fill(color = "lightgray", alpha = 0.5), 
                         cell_text(weight = "bold")), 
            locations = cells_body(columns = code)) |> 
  opt_all_caps() |> 
  opt_align_table_header(align = "left") |>
  tab_header(title = md("**ICD-10-PCS** Sections"))
```

<div id="sqeztmimsh" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>@import url("https://fonts.googleapis.com/css2?family=Rubik:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap");
#sqeztmimsh table {
  font-family: Rubik, system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
&#10;#sqeztmimsh thead, #sqeztmimsh tbody, #sqeztmimsh tfoot, #sqeztmimsh tr, #sqeztmimsh td, #sqeztmimsh th {
  border-style: none;
}
&#10;#sqeztmimsh p {
  margin: 0;
  padding: 0;
}
&#10;#sqeztmimsh .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}
&#10;#sqeztmimsh .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}
&#10;#sqeztmimsh .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}
&#10;#sqeztmimsh .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}
&#10;#sqeztmimsh .gt_heading {
  background-color: #FFFFFF;
  text-align: left;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#sqeztmimsh .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#sqeztmimsh .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#sqeztmimsh .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 80%;
  font-weight: bolder;
  text-transform: uppercase;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}
&#10;#sqeztmimsh .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 80%;
  font-weight: bolder;
  text-transform: uppercase;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}
&#10;#sqeztmimsh .gt_column_spanner_outer:first-child {
  padding-left: 0;
}
&#10;#sqeztmimsh .gt_column_spanner_outer:last-child {
  padding-right: 0;
}
&#10;#sqeztmimsh .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}
&#10;#sqeztmimsh .gt_spanner_row {
  border-bottom-style: hidden;
}
&#10;#sqeztmimsh .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 80%;
  font-weight: bolder;
  text-transform: uppercase;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}
&#10;#sqeztmimsh .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 80%;
  font-weight: bolder;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}
&#10;#sqeztmimsh .gt_from_md > :first-child {
  margin-top: 0;
}
&#10;#sqeztmimsh .gt_from_md > :last-child {
  margin-bottom: 0;
}
&#10;#sqeztmimsh .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}
&#10;#sqeztmimsh .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 80%;
  font-weight: bolder;
  text-transform: uppercase;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#sqeztmimsh .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}
&#10;#sqeztmimsh .gt_row_group_first td {
  border-top-width: 2px;
}
&#10;#sqeztmimsh .gt_row_group_first th {
  border-top-width: 2px;
}
&#10;#sqeztmimsh .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#sqeztmimsh .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}
&#10;#sqeztmimsh .gt_first_summary_row.thick {
  border-top-width: 2px;
}
&#10;#sqeztmimsh .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#sqeztmimsh .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#sqeztmimsh .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}
&#10;#sqeztmimsh .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}
&#10;#sqeztmimsh .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}
&#10;#sqeztmimsh .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#sqeztmimsh .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#sqeztmimsh .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#sqeztmimsh .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#sqeztmimsh .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#sqeztmimsh .gt_left {
  text-align: left;
}
&#10;#sqeztmimsh .gt_center {
  text-align: center;
}
&#10;#sqeztmimsh .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}
&#10;#sqeztmimsh .gt_font_normal {
  font-weight: normal;
}
&#10;#sqeztmimsh .gt_font_bold {
  font-weight: bold;
}
&#10;#sqeztmimsh .gt_font_italic {
  font-style: italic;
}
&#10;#sqeztmimsh .gt_super {
  font-size: 65%;
}
&#10;#sqeztmimsh .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}
&#10;#sqeztmimsh .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}
&#10;#sqeztmimsh .gt_indent_1 {
  text-indent: 5px;
}
&#10;#sqeztmimsh .gt_indent_2 {
  text-indent: 10px;
}
&#10;#sqeztmimsh .gt_indent_3 {
  text-indent: 15px;
}
&#10;#sqeztmimsh .gt_indent_4 {
  text-indent: 20px;
}
&#10;#sqeztmimsh .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_heading">
      <td colspan="2" class="gt_heading gt_title gt_font_normal gt_bottom_border" style><strong>ICD-10-PCS</strong> Sections</td>
    </tr>
    &#10;    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="code">code</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="label">label</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="code" class="gt_row gt_center" style="background-color: rgba(211,211,211,0.5); font-weight: bold;">0</td>
<td headers="label" class="gt_row gt_left">Medical and Surgical</td></tr>
    <tr><td headers="code" class="gt_row gt_center" style="background-color: rgba(211,211,211,0.5); font-weight: bold;">1</td>
<td headers="label" class="gt_row gt_left">Obstetrics</td></tr>
    <tr><td headers="code" class="gt_row gt_center" style="background-color: rgba(211,211,211,0.5); font-weight: bold;">2</td>
<td headers="label" class="gt_row gt_left">Placement</td></tr>
    <tr><td headers="code" class="gt_row gt_center" style="background-color: rgba(211,211,211,0.5); font-weight: bold;">3</td>
<td headers="label" class="gt_row gt_left">Administration</td></tr>
    <tr><td headers="code" class="gt_row gt_center" style="background-color: rgba(211,211,211,0.5); font-weight: bold;">4</td>
<td headers="label" class="gt_row gt_left">Measurement and Monitoring</td></tr>
    <tr><td headers="code" class="gt_row gt_center" style="background-color: rgba(211,211,211,0.5); font-weight: bold;">5</td>
<td headers="label" class="gt_row gt_left">Extracorporeal or Systemic Assistance and Performance</td></tr>
    <tr><td headers="code" class="gt_row gt_center" style="background-color: rgba(211,211,211,0.5); font-weight: bold;">6</td>
<td headers="label" class="gt_row gt_left">Extracorporeal or Systemic Therapies</td></tr>
    <tr><td headers="code" class="gt_row gt_center" style="background-color: rgba(211,211,211,0.5); font-weight: bold;">7</td>
<td headers="label" class="gt_row gt_left">Osteopathic</td></tr>
    <tr><td headers="code" class="gt_row gt_center" style="background-color: rgba(211,211,211,0.5); font-weight: bold;">8</td>
<td headers="label" class="gt_row gt_left">Other Procedures</td></tr>
    <tr><td headers="code" class="gt_row gt_center" style="background-color: rgba(211,211,211,0.5); font-weight: bold;">9</td>
<td headers="label" class="gt_row gt_left">Chiropractic</td></tr>
    <tr><td headers="code" class="gt_row gt_center" style="background-color: rgba(211,211,211,0.5); font-weight: bold;">B</td>
<td headers="label" class="gt_row gt_left">Imaging</td></tr>
    <tr><td headers="code" class="gt_row gt_center" style="background-color: rgba(211,211,211,0.5); font-weight: bold;">C</td>
<td headers="label" class="gt_row gt_left">Nuclear Medicine</td></tr>
    <tr><td headers="code" class="gt_row gt_center" style="background-color: rgba(211,211,211,0.5); font-weight: bold;">D</td>
<td headers="label" class="gt_row gt_left">Radiation Therapy</td></tr>
    <tr><td headers="code" class="gt_row gt_center" style="background-color: rgba(211,211,211,0.5); font-weight: bold;">F</td>
<td headers="label" class="gt_row gt_left">Physical Rehabilitation and Diagnostic Audiology</td></tr>
    <tr><td headers="code" class="gt_row gt_center" style="background-color: rgba(211,211,211,0.5); font-weight: bold;">G</td>
<td headers="label" class="gt_row gt_left">Mental Health</td></tr>
    <tr><td headers="code" class="gt_row gt_center" style="background-color: rgba(211,211,211,0.5); font-weight: bold;">H</td>
<td headers="label" class="gt_row gt_left">Substance Abuse Treatment</td></tr>
    <tr><td headers="code" class="gt_row gt_center" style="background-color: rgba(211,211,211,0.5); font-weight: bold;">X</td>
<td headers="label" class="gt_row gt_left">New Technology</td></tr>
  </tbody>
  &#10;  
</table>
</div>

## Systems

``` r
system() |> 
  gt()
```

    #> Error in system(): argument "command" is missing, with no default

<br>

## Tables

``` r
table("00X") |> tidyr::unnest(codes)
```

    #> # A tibble: 288 × 6
    #>    section system table description                                  code  label
    #>    <chr>   <chr>  <chr> <chr>                                        <chr> <chr>
    #>  1 0       00     00X   Medical and Surgical, Central Nervous Syste… 00XF… Tran…
    #>  2 0       00     00X   Medical and Surgical, Central Nervous Syste… 00XF… Tran…
    #>  3 0       00     00X   Medical and Surgical, Central Nervous Syste… 00XF… Tran…
    #>  4 0       00     00X   Medical and Surgical, Central Nervous Syste… 00XF… Tran…
    #>  5 0       00     00X   Medical and Surgical, Central Nervous Syste… 00XF… Tran…
    #>  6 0       00     00X   Medical and Surgical, Central Nervous Syste… 00XF… Tran…
    #>  7 0       00     00X   Medical and Surgical, Central Nervous Syste… 00XF… Tran…
    #>  8 0       00     00X   Medical and Surgical, Central Nervous Syste… 00XF… Tran…
    #>  9 0       00     00X   Medical and Surgical, Central Nervous Syste… 00XF… Tran…
    #> 10 0       00     00X   Medical and Surgical, Central Nervous Syste… 00XF… Tran…
    #> # ℹ 278 more rows

## Medical and Surgical

``` r
bypass <- definitions() |> 
  dplyr::filter(code == "0", axis == "3", label == "Bypass") |> 
  dplyr::select(label, definition, explanation, includes)
```

    #> Error in definitions(): could not find function "definitions"

``` r
code <- pcs("0016070")

x <- dplyr::left_join(code, bypass, by = dplyr::join_by(label))
```

    #> Error in is.data.frame(y): object 'bypass' not found

``` r
code |> 
  gt(rowname_col = "axis") |> 
  opt_table_font(font = google_font(name = "Rubik")) |> 
  cols_align(align = "center", columns = c(axis, code)) |>
  tab_style(style = list(cell_fill(color = "lightgray", alpha = 0.5), 
                         cell_text(weight = "bold")), 
            locations = cells_body(columns = code)) |> 
  opt_all_caps() |> 
  opt_align_table_header(align = "left") |>
  tab_header(title = html("<b>ICD-10-PCS</b> 2024<hr>"),
             subtitle = html("<small>SECTION:</small> <b>0</b> Medical and Surgical<br>
                              <small>SYSTEM:</small> <b>0</b> Central Nervous System and Cranial Nerves<br>
                              <small>OPERATION:</small> <b>1</b> Bypass<br><br>")) |> 
  sub_missing(missing_text = "")
```

<div id="wcsdsykzhf" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>@import url("https://fonts.googleapis.com/css2?family=Rubik:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap");
#wcsdsykzhf table {
  font-family: Rubik, system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
&#10;#wcsdsykzhf thead, #wcsdsykzhf tbody, #wcsdsykzhf tfoot, #wcsdsykzhf tr, #wcsdsykzhf td, #wcsdsykzhf th {
  border-style: none;
}
&#10;#wcsdsykzhf p {
  margin: 0;
  padding: 0;
}
&#10;#wcsdsykzhf .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}
&#10;#wcsdsykzhf .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}
&#10;#wcsdsykzhf .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}
&#10;#wcsdsykzhf .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}
&#10;#wcsdsykzhf .gt_heading {
  background-color: #FFFFFF;
  text-align: left;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#wcsdsykzhf .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#wcsdsykzhf .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#wcsdsykzhf .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 80%;
  font-weight: bolder;
  text-transform: uppercase;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}
&#10;#wcsdsykzhf .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 80%;
  font-weight: bolder;
  text-transform: uppercase;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}
&#10;#wcsdsykzhf .gt_column_spanner_outer:first-child {
  padding-left: 0;
}
&#10;#wcsdsykzhf .gt_column_spanner_outer:last-child {
  padding-right: 0;
}
&#10;#wcsdsykzhf .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}
&#10;#wcsdsykzhf .gt_spanner_row {
  border-bottom-style: hidden;
}
&#10;#wcsdsykzhf .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 80%;
  font-weight: bolder;
  text-transform: uppercase;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}
&#10;#wcsdsykzhf .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 80%;
  font-weight: bolder;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}
&#10;#wcsdsykzhf .gt_from_md > :first-child {
  margin-top: 0;
}
&#10;#wcsdsykzhf .gt_from_md > :last-child {
  margin-bottom: 0;
}
&#10;#wcsdsykzhf .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}
&#10;#wcsdsykzhf .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 80%;
  font-weight: bolder;
  text-transform: uppercase;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#wcsdsykzhf .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}
&#10;#wcsdsykzhf .gt_row_group_first td {
  border-top-width: 2px;
}
&#10;#wcsdsykzhf .gt_row_group_first th {
  border-top-width: 2px;
}
&#10;#wcsdsykzhf .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#wcsdsykzhf .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}
&#10;#wcsdsykzhf .gt_first_summary_row.thick {
  border-top-width: 2px;
}
&#10;#wcsdsykzhf .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#wcsdsykzhf .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#wcsdsykzhf .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}
&#10;#wcsdsykzhf .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}
&#10;#wcsdsykzhf .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}
&#10;#wcsdsykzhf .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#wcsdsykzhf .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#wcsdsykzhf .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#wcsdsykzhf .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#wcsdsykzhf .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#wcsdsykzhf .gt_left {
  text-align: left;
}
&#10;#wcsdsykzhf .gt_center {
  text-align: center;
}
&#10;#wcsdsykzhf .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}
&#10;#wcsdsykzhf .gt_font_normal {
  font-weight: normal;
}
&#10;#wcsdsykzhf .gt_font_bold {
  font-weight: bold;
}
&#10;#wcsdsykzhf .gt_font_italic {
  font-style: italic;
}
&#10;#wcsdsykzhf .gt_super {
  font-size: 65%;
}
&#10;#wcsdsykzhf .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}
&#10;#wcsdsykzhf .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}
&#10;#wcsdsykzhf .gt_indent_1 {
  text-indent: 5px;
}
&#10;#wcsdsykzhf .gt_indent_2 {
  text-indent: 10px;
}
&#10;#wcsdsykzhf .gt_indent_3 {
  text-indent: 15px;
}
&#10;#wcsdsykzhf .gt_indent_4 {
  text-indent: 20px;
}
&#10;#wcsdsykzhf .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_heading">
      <td colspan="4" class="gt_heading gt_title gt_font_normal" style><b>ICD-10-PCS</b> 2024<hr></td>
    </tr>
    <tr class="gt_heading">
      <td colspan="4" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style><small>SECTION:</small> <b>0</b> Medical and Surgical<br>
                              <small>SYSTEM:</small> <b>0</b> Central Nervous System and Cranial Nerves<br>
                              <small>OPERATION:</small> <b>1</b> Bypass<br><br></td>
    </tr>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id=""></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="name">name</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="code">code</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="label">label</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><th id="stub_1_1" scope="row" class="gt_row gt_center gt_stub">1</th>
<td headers="stub_1_1 name" class="gt_row gt_left">Section</td>
<td headers="stub_1_1 code" class="gt_row gt_center" style="background-color: rgba(211,211,211,0.5); font-weight: bold;">0</td>
<td headers="stub_1_1 label" class="gt_row gt_left">Medical and Surgical</td></tr>
    <tr><th id="stub_1_2" scope="row" class="gt_row gt_center gt_stub">2</th>
<td headers="stub_1_2 name" class="gt_row gt_left">Body System</td>
<td headers="stub_1_2 code" class="gt_row gt_center" style="background-color: rgba(211,211,211,0.5); font-weight: bold;">0</td>
<td headers="stub_1_2 label" class="gt_row gt_left">Central Nervous System and Cranial Nerves</td></tr>
    <tr><th id="stub_1_3" scope="row" class="gt_row gt_center gt_stub">3</th>
<td headers="stub_1_3 name" class="gt_row gt_left">Root Operation</td>
<td headers="stub_1_3 code" class="gt_row gt_center" style="background-color: rgba(211,211,211,0.5); font-weight: bold;">1</td>
<td headers="stub_1_3 label" class="gt_row gt_left">Bypass</td></tr>
    <tr><th id="stub_1_4" scope="row" class="gt_row gt_center gt_stub">4</th>
<td headers="stub_1_4 name" class="gt_row gt_left">Body Part</td>
<td headers="stub_1_4 code" class="gt_row gt_center" style="background-color: rgba(211,211,211,0.5); font-weight: bold;">6</td>
<td headers="stub_1_4 label" class="gt_row gt_left">Cerebral Ventricle</td></tr>
    <tr><th id="stub_1_5" scope="row" class="gt_row gt_center gt_stub">5</th>
<td headers="stub_1_5 name" class="gt_row gt_left">Approach</td>
<td headers="stub_1_5 code" class="gt_row gt_center" style="background-color: rgba(211,211,211,0.5); font-weight: bold;">0</td>
<td headers="stub_1_5 label" class="gt_row gt_left">Open</td></tr>
    <tr><th id="stub_1_6" scope="row" class="gt_row gt_center gt_stub">6</th>
<td headers="stub_1_6 name" class="gt_row gt_left">Device</td>
<td headers="stub_1_6 code" class="gt_row gt_center" style="background-color: rgba(211,211,211,0.5); font-weight: bold;">7</td>
<td headers="stub_1_6 label" class="gt_row gt_left">Autologous Tissue Substitute</td></tr>
    <tr><th id="stub_1_7" scope="row" class="gt_row gt_center gt_stub">7</th>
<td headers="stub_1_7 name" class="gt_row gt_left">Qualifier</td>
<td headers="stub_1_7 code" class="gt_row gt_center" style="background-color: rgba(211,211,211,0.5); font-weight: bold;">0</td>
<td headers="stub_1_7 label" class="gt_row gt_left">Nasopharynx</td></tr>
  </tbody>
  &#10;  
</table>
</div>

<br>

### Obstetrics

``` r
pcs("10D20ZZ")
```

    #> # A tibble: 7 × 4
    #>   axis  name           code  label                          
    #>   <chr> <chr>          <chr> <chr>                          
    #> 1 1     Section        1     Obstetrics                     
    #> 2 2     Body System    0     Pregnancy                      
    #> 3 3     Root Operation D     Extraction                     
    #> 4 4     Body Part      2     Products of Conception, Ectopic
    #> 5 5     Approach       0     Open                           
    #> 6 6     Device         Z     No Device                      
    #> 7 7     Qualifier      Z     No Qualifier

<br>

### Placement

``` r
pcs("2W0UX0Z")
```

    #> # A tibble: 7 × 4
    #>   axis  name           code  label             
    #>   <chr> <chr>          <chr> <chr>             
    #> 1 1     Section        2     Placement         
    #> 2 2     Body System    W     Anatomical Regions
    #> 3 3     Root Operation 0     Change            
    #> 4 4     Body Region    U     Toe, Right        
    #> 5 5     Approach       X     External          
    #> 6 6     Device         0     Traction Apparatus
    #> 7 7     Qualifier      Z     No Qualifier

<br>

### Administration

``` r
pcs("3E1938X")
```

    #> # A tibble: 7 × 4
    #>   axis  name                 code  label                                       
    #>   <chr> <chr>                <chr> <chr>                                       
    #> 1 1     Section              3     Administration                              
    #> 2 2     Body System          E     Physiological Systems and Anatomical Regions
    #> 3 3     Root Operation       1     Irrigation                                  
    #> 4 4     Body System / Region 9     Nose                                        
    #> 5 5     Approach             3     Percutaneous                                
    #> 6 6     Substance            8     Irrigating Substance                        
    #> 7 7     Qualifier            X     Diagnostic

<br>

### Measurement and Monitoring

``` r
pcs("4B01XVZ")
```

    #> # A tibble: 7 × 4
    #>   axis  name              code  label                     
    #>   <chr> <chr>             <chr> <chr>                     
    #> 1 1     Section           4     Measurement and Monitoring
    #> 2 2     Body System       B     Physiological Devices     
    #> 3 3     Root Operation    0     Measurement               
    #> 4 4     Body System       1     Peripheral Nervous        
    #> 5 5     Approach          X     External                  
    #> 6 6     Function / Device V     Stimulator                
    #> 7 7     Qualifier         Z     No Qualifier

<br>

### Extracorporeal or Systemic Assistance and Performance

``` r
pcs("5A02110")
```

    #> # A tibble: 7 × 4
    #>   axis  name           code  label                                              
    #>   <chr> <chr>          <chr> <chr>                                              
    #> 1 1     Section        5     Extracorporeal or Systemic Assistance and Performa…
    #> 2 2     Body System    A     Physiological Systems                              
    #> 3 3     Root Operation 0     Assistance                                         
    #> 4 4     Body System    2     Cardiac                                            
    #> 5 5     Duration       1     Intermittent                                       
    #> 6 6     Function       1     Output                                             
    #> 7 7     Qualifier      0     Balloon Pump

<br>

### Extracorporeal or Systemic Therapies

``` r
pcs("6A0Z0ZZ")
```

    #> # A tibble: 7 × 4
    #>   axis  name           code  label                               
    #>   <chr> <chr>          <chr> <chr>                               
    #> 1 1     Section        6     Extracorporeal or Systemic Therapies
    #> 2 2     Body System    A     Physiological Systems               
    #> 3 3     Root Operation 0     Atmospheric Control                 
    #> 4 4     Body System    Z     None                                
    #> 5 5     Duration       0     Single                              
    #> 6 6     Qualifier      Z     No Qualifier                        
    #> 7 7     Qualifier      Z     No Qualifier

<br>

### Osteopathic

``` r
pcs("7W00X0Z")
```

    #> # A tibble: 7 × 4
    #>   axis  name           code  label               
    #>   <chr> <chr>          <chr> <chr>               
    #> 1 1     Section        7     Osteopathic         
    #> 2 2     Body System    W     Anatomical Regions  
    #> 3 3     Root Operation 0     Treatment           
    #> 4 4     Body Region    0     Head                
    #> 5 5     Approach       X     External            
    #> 6 6     Method         0     Articulatory-Raising
    #> 7 7     Qualifier      Z     None

<br>

### Other Procedures

``` r
pcs("8C01X6J")
```

    #> # A tibble: 7 × 4
    #>   axis  name           code  label              
    #>   <chr> <chr>          <chr> <chr>              
    #> 1 1     Section        8     Other Procedures   
    #> 2 2     Body System    C     Indwelling Device  
    #> 3 3     Root Operation 0     Other Procedures   
    #> 4 4     Body Region    1     Nervous System     
    #> 5 5     Approach       X     External           
    #> 6 6     Method         6     Collection         
    #> 7 7     Qualifier      J     Cerebrospinal Fluid

<br>

### Chiropractic

``` r
pcs("9WB0XBZ")
```

    #> # A tibble: 7 × 4
    #>   axis  name           code  label             
    #>   <chr> <chr>          <chr> <chr>             
    #> 1 1     Section        9     Chiropractic      
    #> 2 2     Body System    W     Anatomical Regions
    #> 3 3     Root Operation B     Manipulation      
    #> 4 4     Body Region    0     Head              
    #> 5 5     Approach       X     External          
    #> 6 6     Method         B     Non-Manual        
    #> 7 7     Qualifier      Z     None

<br>

### Imaging

``` r
pcs("B00B0ZZ")
```

    #> Error in `dplyr::tibble()`:
    #> ! Tibble columns must have compatible sizes.
    #> • Size 0: Existing data.
    #> • Size 3: Column `name`.
    #> ℹ Only values of size one are recycled.

<br>

### Nuclear Medicine

``` r
pcs("C0101ZZ")
```

    #> Error in `dplyr::tibble()`:
    #> ! Tibble columns must have compatible sizes.
    #> • Size 0: Existing data.
    #> • Size 3: Column `name`.
    #> ℹ Only values of size one are recycled.

<br>

### Radiation Therapy

``` r
pcs("DG22DZZ")
```

    #> Error in `dplyr::tibble()`:
    #> ! Tibble columns must have compatible sizes.
    #> • Size 0: Existing data.
    #> • Size 3: Column `name`.
    #> ℹ Only values of size one are recycled.

<br>

### Physical Rehabilitation and Diagnostic Audiology

``` r
pcs("F14Z01Z")
```

    #> Error in `dplyr::tibble()`:
    #> ! Tibble columns must have compatible sizes.
    #> • Size 0: Existing data.
    #> • Size 3: Column `name`.
    #> ℹ Only values of size one are recycled.

<br>

### Mental Health

``` r
pcs("GZ10ZZZ")
```

    #> Error in `dplyr::tibble()`:
    #> ! Tibble columns must have compatible sizes.
    #> • Size 0: Existing data.
    #> • Size 3: Column `name`.
    #> ℹ Only values of size one are recycled.

<br>

### Substance Abuse Treatment

``` r
pcs("HZ96ZZZ")
```

    #> Error in `dplyr::tibble()`:
    #> ! Tibble columns must have compatible sizes.
    #> • Size 0: Existing data.
    #> • Size 3: Column `name`.
    #> ℹ Only values of size one are recycled.

<br>

### New Technology

``` r
pcs("XY0YX37")
```

    #> # A tibble: 7 × 4
    #>   axis  name                            code  label                   
    #>   <chr> <chr>                           <chr> <chr>                   
    #> 1 1     Section                         X     New Technology          
    #> 2 2     Body System                     Y     Extracorporeal          
    #> 3 3     Root Operation                  0     Introduction            
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
