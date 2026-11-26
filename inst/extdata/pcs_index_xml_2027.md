# ICD-10-PCS Index Document Definition

Last Updated: 6 June 2011

The ICD-10-PCS Index XML provides the content displayed in the PCS index portion
of the pcs_year.pdf. The XML file follows the PDF closely, so interpretation of
the XML can most easily be obtained by comparing the XML file with the PDF for
the same version.

The PCS index is a tree of terms with references to other terms, to PCS code
tables, to codes within a PCS code table, or to individual PCS codes. The tree
begins with up to 26 branches, one for each letter of the alphabet, identified
with "letter" tags. Within each letter, the the terms are identified as
"mainTerm" and are generally displayed bold in the PDF document. Main terms may
have subterms, which in turn may have further subterms. The current maximum
depth is nine levels. The terms are generally in alphabetical order at each
level, but there are may be exceptions. Subterms under the main term or under
each other are identified by "term" tags, with a "level" attribute.

A mainTerm or a term will contain a "title" representing the term text. It may
then refer to other information in the document. A "tab" tag contains the
three-character identification of a PCS table. A "codes" tag starts with the
three-character identification of a PCS table and may contain further
restrictions on the codes related to the term. Documents which do not wish to
direct the user any deeper than the table may display only the first three
characters and thereby treat the "codes" tag the same as a "tab" tag. The "code"
tag refers to a single, complete, valid PCS code. The "see" tag refers at least
to a main term, and possibly (after commas) to terms at lower levels. A "use"
tag refers to synonyms used in the index, but which are not themselves main
terms. Not all terms will have one of these references. Terms with or without
references may contain subterms.
