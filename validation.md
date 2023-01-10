# MARC 21 validation

## ... with yaz-marcdump

The command-line tool `yaz-marcdump` can be used for several MARC related tasks. 

To validate the structure of "MARC (ISO 2709)" records use the option `-n`, which will omit any other output:

```terminal
$ yaz-marcdump -n loc.mrc
```

If you want to validate records in other MARC formats you have to specify the format with option `-i`:

```terminal
$ yaz-marcdump -n -i marcxml loc.mrc.xml
```

If `yaz-marcdump` finds any errors it will output an error message:

```terminal
$ yaz-marcdump -n bad_hathi_records.mrc 
<!-- EOF while searching for RS -->
```

To narrow down the error use option `-p`, which will print the record numbers and offsets:

```terminal
$ yaz-marcdump -np bad_hathi_records.mrc 
<!-- Record 1 offset 0 (0x0) -->
<!-- Record 2 offset 1293 (0x50d) -->
<!-- Record 3 offset 5259 (0x148b) -->
<!-- Record 4 offset 6343 (0x18c7) -->
<!-- EOF while searching for RS -->
```


[Common structural problems](https://bibwild.wordpress.com/2010/02/02/structural-marc-problems-you-may-encounter/) in MARC records are:

* Invalid leader bytes

```terminal
$ yaz-marcdump -np bad_leaders_10_11.mrc 
<!-- Record 1 offset 0 (0x0) -->
Indicator length at offset 10 should hold a number 1-9. Assuming 2
Identifier length at offset 11 should  hold a number 1-9. Assuming 2
Length data entry at offset 20 should hold a number 3-9. Assuming 4
Length starting at offset 21 should hold a number 4-9. Assuming 5
Length implementation at offset 22 should hold a number. Assuming 0
```

* Record exceeds the maximum length

```terminal
$ yaz-marcdump -np bad_hathi_records.mrc 
<!-- Record 1 offset 0 (0x0) -->
<!-- Record 2 offset 1293 (0x50d) -->
<!-- Record 3 offset 5259 (0x148b) -->
<!-- Record 4 offset 6343 (0x18c7) -->
<!-- EOF while searching for RS -->
```

* Field exceeds the maximum length

```terminal
$ yaz-marcdump -np bad_oversize_field_bad_directory.mrc 
<!-- Record 1 offset 0 (0x0) -->
<!-- Record 2 offset 1571 (0x623) -->
Directory offset 240: Bad value for data length and/or length starting (0\x1Edrd-348919)
Base address not at end of directory, base 242, end 241
Directory offset 216: Data out of bounds 21398 >= 11833
<!-- Record 3 offset 13404 (0x345c) -->
<!-- Record 4 offset 16133 (0x3f05) -->
<!-- Record 5 offset 18823 (0x4987) -->
```

* Invalid subfield element

```terminal
$ yaz-marcdump -np -i marcxml chabon-bad-subfields-element.xml 
yaz_marc_read_xml failed
```

* MARC control character in internal data value

```terminal
$ yaz-marcdump -np bad_data_value.mrc 
<!-- Record 1 offset 0 (0x0) -->
Separator but not at end of field length=37
```

* Wrong encoded character

```terminal
$ yaz-marcdump -np bad_encoding.mrc 
<!-- Record 1 offset 0 (0x0) -->
No separator at end of field length=53
No separator at end of field length=64
```

## ... with xmllint


Use `xmllint` to validate "MARC XML" data against the MARC [XSD schema](https://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd).

If you just want validate the structure of "MARC XML" records, use the options `--noout` (which will omit any other output) and `--schema` (path to XSD file):

```terminal
$ xmllint --noout --schema http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd loc.mrc.xml
loc.mrc.xml validates
$ xmllint --noout --schema http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd chabon-bad-subfields-element.xml
chabon-bad-subfields-element.xml:8: element subfields: Schemas validity error : Element '{http://www.loc.gov/MARC21/slim}subfields': This element is not expected. Expected is ( {http://www.loc.gov/MARC21/slim}subfield ).
chabon-bad-subfields-element.xml fails to validate
``` 

## ... with marcvalidate

While `yaz-marcdump` and `xmllint` are useful to identify structural problems within MARC records, `marcvalidate` can be used to validate MARC tags and subfields against an [Avram](https://format.gbv.de/schema/avram/specification) specification. The default specification was build by [Péter Király](https://pkiraly.github.io/2018/01/28/marc21-in-json/) based on the MARC documentation of the Library of Congress. The specification can be enhanced with local defined fields.

By default `marcvalidate` expects "MARC (ISO 2709)" records:

```terminal
$ marcvalidate loc.mrc
12360325    906 unknown field    
1180649 035 unknown subfield    9
...
```

To validate "MARC XML" data use option `--type`:

```terminal
$ marcvalidate --type XML loc.mrc.xml
12360325    906 unknown field    
1180649 035 unknown subfield    9
...
```

To validate against a local Avram schema use option `--schema`:

```terminal
$ marcvalidate --schema my_schema.json loc.mrc
```

If you want to run more detailed analyses check "[QA catalogues - a metadata quality assessment tool for MARC records](https://github.com/pkiraly/metadata-qa-marc)".
