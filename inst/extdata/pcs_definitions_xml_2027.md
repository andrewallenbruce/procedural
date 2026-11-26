# ICD-10-PCS Reference Section Definition

Last Updated: 6 June 2011

The ICD-10-PCS Definitions XML provides the content displayed in the PCS
reference portion of the pcs_year.pdf. The XML file mostly follows the PDF, so
interpretation of the XML can most easily be obtained by comparing the XML file
with the PDF for the same version.

The reference section in the PDF consists of four parts: the definitions, the
body part key, the device key, and the device aggregation table. Since the body
part key and the device key are merely reverse sorts of the body part and device
definitions respectively, they are not explicitly represented in the XML file,
as that would be repeating content already provided in the definition section.
The XML file contains definitions in "section" tags, and the device aggregation
table in a "deviceAggregation" tag.

The meaning of different axes of classification in a PCS code depend on which
section the code is found in. The section is identified by the first character
of the code. Definitions of terms must therefore depend on section, so the top
level tag for definitions is the "section" tag, with a "code" attribute to
identify what value is found in the first character of a code to denote the
section, and a "title" sub-tag to provide the standard name of the section.

Within a section, for each axis of classification with definitions, an "axis"
tag introduces the axis. Its "pos" attribute defines its place in the code
structure (a number from 1 through 7) and its "title" sub-tag gives its standard
name. Each defined term then follows within a "term" tag. The "title" sub-tag of
the term gives its PCS label, which may then be followed by "definition",
"explanation" and/or "includes" tags. The "definition", if present, gives the
precise PCS definition of the term. The "explanation", if present, provides
further elaboration, and "includes", if present, gives a common terminology
synonym that the coder may encounter in the medical record. Note that a term may
have more than one "includes".

The deviceAggregation section serves to identify the relationships between a
specific devices (as used by insertion and other operations) and their general
counterparts (as used by removal and other operations). Each such relationship
is specified by an "aggregate" tag. The specific devices in the aggregate are
identified by "device", "operation" and "bodySys", which list the specific
device name, the operation or operations in which it may be specified, and the
body systems it may be used with, respectively. The associated general device is
given by the "parent" tag, whose "value" attribute gives the PCS sixth-character
value to use and whose text gives the general device name.
