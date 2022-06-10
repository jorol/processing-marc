# Extract data from MARC records

## ... with xmllint 

First check if a [XML namespace](https://www.w3.org/TR/xml-names/) is declared in the document:

```terminal
$ head loc.mrc.xml
<collection xmlns="http://www.loc.gov/MARC21/slim">
<record>
  <leader>01227cam a22002894a 4500</leader>
  <controlfield tag="001">12360325</controlfield>
  <controlfield tag="005">20070126075126.0</controlfield>
  <controlfield tag="008">010327s2001    nyua          001 0 eng  </controlfield>
  <datafield tag="906" ind1=" " ind2=" ">
    <subfield code="a">7</subfield>
    <subfield code="b">cbc</subfield>
    <subfield code="c">orignew</subfield>
```

If a namespace is set use the "local" XML element name in the [XPATH](https://www.w3.org/TR/2017/REC-xpath-31-20170321/) expression:

```
$ xmllint --xpath '//*[local-name()="controlfield"]/@tag' loc.mrc.xml 
```

Extract all tags and count them:

```terminal
$ xmllint --xpath '//@tag' loc.mrc.xml | sort | uniq -c
```

Extract all IDs from MARC 001:

```terminal
$ xmllint --xpath '//*[local-name()="controlfield"][@tag="001"]/text()'  loc.mrc.xml
```

Extract all subfields from MARC 245 fields:

```terminal
$ xmllint --xpath '//*[local-name()="datafield"][@tag="245"]' loc.mrc.xml
```

Extract subfield "a" from MARC 245 fields:

```terminal
$ xmllint --xpath '//*[local-name()="datafield"][@tag="245"]/*[local-name()="subfield"][@code="a"]/' loc.mrc.xml
```

Extract content from subfield "a" from MARC 245 fields:

```terminal
$ xmllint --xpath '//*[local-name()="datafield"][@tag="245"]/*[local-name()="subfield"][@code="a"]/text()' loc.mrc.xml
```

Extraxt all ISBNs:

```terminal
$ xmllint --xpath '//*[local-name()="datafield"][@tag="020"]/*[local-name()="subfield"][@code="a"]/text()' loc.mrc.xml
```

Extract all DDC numbers:

```terminal
$ xmllint --xpath '//*[local-name()="datafield"][@tag="082"]/*[local-name()="subfield"][@code="a"]/text()' loc.mrc.xml
```

## ... with Catmandu

Catmandu uses a [domain specific language](https://en.wikipedia.org/wiki/Domain-specific_language) (DSL) called "fix" to extract, map and tranform data. Several "fixes" for library specifc data formats like [MARC](https://metacpan.org/pod/Catmandu::MARC) and [PICA](https://metacpan.org/pod/Catmandu::PICA) are available. Most common "fixes" are documented on a [cheat sheet](https://librecat.org/assets/catmandu_cheat_sheet.pdf). "Fixes" can be used as command-line options or stored in a "fix" file:

```terminal
$ catmandu convert MARC to CSV --fix 'marc_map(001,id); retain_field(id)' < loc.mrc
$ catmandu convert MARC to YAML --fix marc2dc.fix  < loc.mrc
```

### marc_map

With [`marc_map`](https://metacpan.org/pod/Catmandu::Fix::marc_map) you can extract (sub)fields from MARC records and map them to your own data model: 

```
marc_map(001,dc_identifier)
# {"dc_identifier":"12360325"}
```

### Extract part of field

MARC uses several "fixed-length" fields, where data elements are positionally defined. E.g. if you want to extract the language code from MARC 008 specify the positions with `/35-37`:

```
marc_map(008/35-37,dc_language)
# {"dc_language":"eng"}
```

### Extract fields with specific indicators

If you want to extract fields with certain indicators specify them within sqare brackes `[1,4]` 

```
marc_map('246[1,4]',marc_varyingFormOfTitle)
# {"marc_varyingFormOfTitle":"Games, diversions & Perl culture"}
```


### Extract subfields

To extract certain subfields from a MARC data field use the subfield codes. By default several subfields will be joined to one string. Use option `join` to join them with another string. With option `split` you can split the subfields to a list. Use option `pluck` if you want to extract the subfields in a certain order. 

```
marc_map(245ab,dc_title,join:' ')
# {"dc_title":"Perl : the complete reference /"}
marc_map(245ab,dc_title,split:1)
# {"dc_title":["Perl :","the complete reference /"]}
marc_map(245ba,dc_title,split:1,pluck:1)
# {"dc_title":["the complete reference /","Perl :"]}
```

### Extract repeatable fields

MARC data fields could be repeatable. Use option `split` to create a list from all fields. 

```
marc_map(650a,dc_subject,split:1)
# {"dc_subject":["Data mining.","Text processing (Computer science)","Perl (Computer program language)"]}
```

### Extract repeatable subfields

MARC subfields could be repeatable within a MARC data field. Use option `split:1` to create a list from all fields. To create a list for all subfields within one data field use option `nested_arrays:1` which will return a "list of lists" of subfields, one list for each data field. 

```
marc_map(655ay,marc_indexTermGenre,split:1)
# {"marc_indexTermGenre":["Portrait photographs","1910-1920.","Photographic prints","1910-1920."]}
marc_map(655ay,marc_indexTermGenre,split:1,nested_arrays:1)
# {"marc_indexTermGenre":[["Portrait photographs","1910-1920."],["Photographic prints","1910-1920."]]}
```

### Extract subfields by value

To extract a subfield only if another subfield in the same data field has a certain value use a [loop](https://metacpan.org/pod/Catmandu::Fix::Bind::marc_each) with a [condition](https://metacpan.org/pod/Catmandu::Fix::Condition).

```
=856  4\$uhttp://journal.code4lib.org/$xVerlag$zkostenfrei
=856  4\$uhttp://www.bibliothek.uni-regensburg.de/ezeit/?2415107$xEZB
```

```
do marc_each()
  if marc_match(856x,EZB)
    marc_map(856u,ezb_uri)
  end
end
# {"ezb_uri":"http://www.bibliothek.uni-regensburg.de/ezeit/?2415107"}
```

### Conditions

Use conditions [`marc_has`](https://metacpan.org/pod/Catmandu::Fix::Condition::marc_has), [`marc_has_many`](https://metacpan.org/pod/Catmandu::Fix::Condition::marc_has_many) or [`marc_match`](https://metacpan.org/pod/Catmandu::Fix::Condition::marc_match) to check if an record has certain fields or match certain conditions.

```
set_array(errors)

# Check if a 245 field is present
unless marc_has('245')
  set_field(errors.$append,"no 245 field")
end
 
# Check if there is more than one 245 field
if marc_has_many('245')
  set_field(errors.$append,"more than one 245 field?")
end
 
# Check if in 008 position 7 to 10 contains a 
# 4 digit number ('\d' means digit)
unless marc_match('008/07-10','\d{4}')
  set_field(errors.$append,"no 4-digit year in 008 position 7->10")
end
``` 

### Add fields to a record

You can add fields to MARC records with [`marc_add`](https://metacpan.org/pod/Catmandu::Fix::marc_add).

```
marc_add(999,a,my,b,local,c,field)
marc_add(900,a,$.my.field)
```

### Append values to (sub)fields

Use [`marc_append`](https://metacpan.org/pod/Catmandu::Fix::marc_append) to append values to a (sub)field

```
marc_append(001,'-X')
marc_append(100a,' [author]')
```

### Assign a value to (sub)fields

Assign a new value to a MARC field with [`marc_set`](https://metacpan.org/pod/Catmandu::Fix::marc_set).

```
marc_set(001,123456789)
marc_set(245a,'Perl - battle tested.')
```

### Remove (sub)fields

Use [`marc_remove`](https://metacpan.org/pod/Catmandu::Fix::marc_remove) to remove (sub)fields from MARC records.

```
marc_remove(991)
marc_remove(9..)
marc_remove(0359)
```

### Replace strings in (sub)fields

Use [`marc_replace_all`](https://metacpan.org/pod/Catmandu::Fix::marc_replace_all) to replace a string in MARC (sub)fields.

```
marc_replace_all(001,1,X)
marc_replace_all(245a,Perl,"Perl [programming language]")
```

### Filter MARC records

You can filter MARC records from a dataset with [`reject`](https://metacpan.org/pod/Catmandu::Fix::reject) or `select`.

```
reject marc_has_many(245)
select marc_match(245a,Perl)
``` 

### Validate MARC records

You can [`validate`](https://metacpan.org/pod/Catmandu::Fix::validate) MARC records and collect the error messages or filter [`valid`](https://metacpan.org/pod/Catmandu::Fix::Condition::valid) records.

```
validate(.,MARC,error_field:errors)
select valid(.,MARC)
``` 

### Dictionaries

MARC uses codes for [languages](https://www.loc.gov/marc/languages/language_code.html) and [countries](https://www.loc.gov/marc/countries/countries_code.html). You can build dictionaries based on these list and [lookup](https://metacpan.org/pod/Catmandu::Fix::lookup) names for these codes.

```
$ less languages.csv
eng,English
enm,English, Middle (1100-1500)
epo,Esperanto
esk,Eskimo languages
est,Estonian
...
```
```
# { "dc_language": "eng" }
lookup(dc_language,languages.csv)
lookup(dc_language,languages.csv,default:English)
lookup(dc_language,languages.csv,delete:1)
# { "dc_language": "English" }
``` 

### Normalize ISBNs and ISSNs

Use [`issn`](https://metacpan.org/pod/Catmandu::Fix::issn),  [`isbn10`](https://metacpan.org/pod/Catmandu::Fix::isbn10) or [`isbn13`](https://metacpan.org/pod/Catmandu::Fix::isbn13) to normalize international identifier.

```
# { "issn" : "1553667x" }
issn(issn)
# { "issn" : "1553-667X" }

# { "isbn" : "1565922573" }
isbn10(isbn) 
# {"isbn" : "1-56592-257-3" }
isbn13(isbn)
# { "isbn" : "978-1-56592-257-0" }
```

## Links

Cheat sheet: http://librecat.org/assets/catmandu_cheat_sheet.pdf

MARC mapping rules: https://github.com/LibreCat/Catmandu-MARC/wiki/Mapping-rules

MARC tutorial: https://metacpan.org/pod/distribution/Catmandu-MARC/lib/Catmandu/MARC/Tutorial.pod

Example "fix" http://librecat.org/Catmandu/#example-fix-script
