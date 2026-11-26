# ICD-10-PCS Tabular XML

Last updated: 5 June 2011

The ICD-10-PCS Tabular XML provides the content displayed in the PCS tables
portion of the `pcs_year.pdf`. The XML file follows the PDF closely, so
interpretation of the XML can most easily be obtained by comparing the XML file
with the PDF for the same version.

The seven characters of a PCS code have a consistent meaning, dependent on the
first character (called the `section`). 

There will be a PCS table for each different combination of the first three
characters, and each PCS table will be included in a `pcsTable` tag. The XML
root section, after version and title information, will just consist of
`pcsTable` sections.

Since each PCS code consists of 7 characters (called **Axes of Classification** 
in the PCS literature), a PCS table will display the 3 values for the first 
3 axes at the top, as they are by definition the same for all the codes 
represented by the table.

In XML, these will be represented by `axis` tags, with `pos` attributes 1, 2 and
3. Each `axis` will contain a `title`, which gives the meaning of the axis in
the section (for example, **Section**, **Body System**, **Operation**), and a 
`label` which gives the PCS value in its `code` attribute and the standard 
description of the value in its text portion.

> The third axis (usually **Operation**), also has a `definition` tag which gives
the formal PCS definition of the value shown in its label.

After the three `axis` tags for the axes that define the table, there will be
one or more lists of combinations of the other four axes that comprise valid PCS
codes. Each such list of combinations is enclosed in a `pcsRow` tag, and is
displayed in the PDF with a line under it. 

Each `pcsRow` entry will have four `axis` tags, with `pos` 4, 5, 6 and 7 
respectively. Each `axis` will have a title, which corresponds to the column 
headings in the PDF (**Body Part**, **Approach**, **Device** and **Qualifier** 
for section zero). 

Each `axis` will have one or more `label` tags, giving the PCS value in the 
its `code` attribute and the standard description of the PCS value in its text 
portion. All combination of labels, one for each axis, in a `pcsRow` section, 
are valid PCS codes.
