# MARC 21 serializations

## MARC (ISO 2709)

A "MARC (ISO 2709)" record ([ISO 2709:2008](https://www.iso.org/standard/41319.html) & [ANSI/NISO Z39.2-1994](https://www.niso.org/publications/ansiniso-z392-1994-r2016)) consists of three parts:

* leader
* directory
* variable fields

The [leader](https://www.loc.gov/marc/specifications/specrecstruc.html#leader) has a fixed length of 24 ASCII characters which provide some basic information for processing the record. Data elements are positionally defined, see https://www.loc.gov/marc/bibliographic/bdleader.html. Leader positions 00-05  define the length of the records. The total length of a "MARC (2709)" record is limited to 99999 bytes. Position 09 defines the "character coding scheme" ([MARC-8](https://www.loc.gov/marc/specifications/specchartables.html) or [Unicode](https://www.iso.org/standard/69119.html)). 

The [directory](https://www.loc.gov/marc/specifications/specrecstruc.html#direct) is variable sequence of entries, describing the tag , length and the starting position of each field. Each directory entry has a length of 12 characters: 

* tag: 00-02
* lengt of field: 03-06
* starting postion: 07-11

The length of a "MARC (2709)" record field is limited to 9999 bytes.

The [variable fields](https://www.loc.gov/marc/specifications/specrecstruc.html#varifields) are [control fields](https://www.loc.gov/marc/bibliographic/bd00x.html) followed by data fields. Data fields consist of two indicators and a sequence of subfields. Indicators can be used interpret or supplement the data found in the field. Their meaning varies by field. Each subfield consists of a subfield code and the corresponding value. Data fields and subfields could be repeatable.

A MARC record is terminated with a record terminator (Unicode character 'INFORMATION SEPARATOR THREE' [U+001D](https://www.fileformat.info/info/unicode/char/001d/index.htm)). Each part of a record is terminated with a field terminator (Unicode character 'INFORMATION SEPARATOR TWO' [U+001E](https://www.fileformat.info/info/unicode/char/001e/index.htm)). Each subfield of the data fields is terminated with a subfield terminator (Unicode character 'INFORMATION SEPARATOR THREE' [U+001F](https://www.fileformat.info/info/unicode/char/001e/index.htm)). 

Example "MARC (ISO 2709)" record:

```
00251nas a2200121 c 4500001001000000007001500010022001400025041000800039245002700047246000900074362001300083856003300096987874829cr||||||||||||  a1940-5758  aeng00aCode4Lib journalbC4LJ3 aC4LJ0 a1.2007 -4 uhttp://journal.code4lib.org/
```

Leader, directory and fields:

```
leader:
00251nas a2200121 c 4500

directory:
001001000000
007001500010
022001400025
041000800039
245002700047
246000900074
362001300083
856003300096<U+001E>

fields:
987874829<U+001E>
cr||||||||||||<U+001E>
  <U+001F>a1940-5758<U+001E>
  <U+001F>aeng<U+001E>
00<U+001F>aCode4Lib journal<U+001F>bC4LJ<U+001E>
3 <U+001F>aC4LJ<U+001E>
0 <U+001F>a1.2007 -<U+001E>
4 <U+001F>uhttp://journal.code4lib.org/<U+001E>
<U+001D>
```

## MARC XML

The Library of Congress provides a [framework](https://www.loc.gov/standards/marcxml/) for working with MARC data in XML environments. The framework consists of a XML schema for MARC data ([XSD](https://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd), [XSD illustration](https://www.loc.gov/standards/marcxml/xml/spy/spy.html)), [XSL stylesheets](https://www.loc.gov/standards/marcxml/#stylesheets) and some [tools](https://www.loc.gov/standards/marcxml/marcxml.zip) for transformation and validation of "MARC XML" data. "MARC XML" is often used to provide MARC data via APIs like [SRU](https://www.loc.gov/standards/sru/index.html) & [OAI](https://www.openarchives.org/pmh/). "MARC XML" defines several ["MARC XML design considerations"](https://www.loc.gov/standards/marcxml/marcxml-design.html), one is the "roundtripability from XML back to MARC". The schema doesn't limit the length of records and fields, so many data providers use "MARC XML" to circumvent the length restriction of "MARC (2709)". 

Example "MARC XML" record:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<collection xmlns="http://www.loc.gov/MARC21/slim">
<record>
  <leader>00251nas a2200121 c 4500</leader>
  <controlfield tag="001">987874829</controlfield>
  <controlfield tag="007">cr||||||||||||</controlfield>
  <datafield tag="022" ind1=" " ind2=" ">
    <subfield code="a">1940-5758</subfield>
  </datafield>
  <datafield tag="041" ind1=" " ind2=" ">
    <subfield code="a">eng</subfield>
  </datafield>
  <datafield tag="245" ind1="0" ind2="0">
    <subfield code="a">Code4Lib journal</subfield>
    <subfield code="b">C4LJ</subfield>
  </datafield>
  <datafield tag="246" ind1="3" ind2=" ">
    <subfield code="a">C4LJ</subfield>
  </datafield>
  <datafield tag="362" ind1="0" ind2=" ">
    <subfield code="a">1.2007 -</subfield>
  </datafield>
  <datafield tag="856" ind1="4" ind2=" ">
    <subfield code="u">http://journal.code4lib.org/</subfield>
  </datafield>
</record>
</collection>
```

## Turbomarc

[Index Data](https://www.indexdata.com/) developed "Turbomarc", another XML serialization for MARC data. The primary development goal of "Turbomarc" was [to speed up](https://www.indexdata.com/turbomarc-faster-xml-marc-records/) the processing of MARC data.

Example "Turbomarc" record:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<collection xmlns="http://www.indexdata.com/turbomarc">
<r>
  <l>00251nas a2200121 c 4500</l>
  <c001>987874829</c001>
  <c007>cr||||||||||||</c007>
  <d022 i1=" " i2=" ">
    <sa>1940-5758</sa>
  </d022>
  <d041 i1=" " i2=" ">
    <sa>eng</sa>
  </d041>
  <d245 i1="0" i2="0">
    <sa>Code4Lib journal</sa>
    <sb>C4LJ</sb>
  </d245>
  <d246 i1="3" i2=" ">
    <sa>C4LJ</sa>
  </d246>
  <d362 i1="0" i2=" ">
    <sa>1.2007 -</sa>
  </d362>
  <d856 i1="4" i2=" ">
    <su>http://journal.code4lib.org/</su>
  </d856>
</r>
</collection>
```

## Line-based MARC formats

There are several line-based MARC formats. These formats offer a more human-readable serialization of MARC records and are often used to examine, create or update MARC records. Several records are divided by a blank line. The formats differ slightly in the representation of MARC tags, indicators and subfield.

### MARC Line

"MARC Line" is a simple line-by-line format also developed by Index Data. It is suitable for display but not recommended for further (machine) processing.  

Example "MARC Line" record:

```
00251nas a2200121 c 4500
001 987874829
007 cr||||||||||||
022    $a 1940-5758
041    $a eng
245 00 $a Code4Lib journal $b C4LJ
246 3  $a C4LJ
362 0  $a 1.2007 -
856 4  $u http://journal.code4lib.org/

```

### MARCMaker

This format was developed to create MARC records without having to use a MARC-based system. It is the most widely used line-based format and supported by several software tools (e.g. Catmandu, MarcEdit) and libraries (e.g. marc4j, pymarc).

Example "MARCMaker" record:

```
=LDR  00251nas a2200121 c 4500
=001  987874829
=007  cr||||||||||||
=022  \\$a1940-5758
=041  \\$aeng
=245  00$aCode4Lib journal$bC4LJ
=246  3\$aC4LJ
=362  0\$a1.2007 -
=856  4\$uhttp://journal.code4lib.org/

```

### MicroLIF

"[MicroLIF](http://web.sonoma.edu/users/h/huangp/MARC_MicroLIF.htm)" is a MARC compatible record format created by a group of publishers and vendors in the '80s.

Example "MircoLIF" record:

```
LDR00251nas a2200121 c 4500^
001987874829^
007cr||||||||||||^
022  _a1940-5758^
041  _aeng^
24500_aCode4Lib journal_bC4LJ^
2463 _aC4LJ^
3620 _a1.2007 -^
8564 _uhttp://journal.code4lib.org/^

```

### Aleph Sequential

"Aleph Sequential" is a line-based serialization format used by Ex Libris Ltd. integrated library systems "[Aleph](https://exlibrisgroup.com/products/aleph-integrated-library-system/)".

Example "Aleph Sequential" record:

```
987874829 FMT   L BK
987874829 LDR   L 00251nas^a2200121^c^4500
987874829 001   L 987874829
987874829 007   L cr||||||||||||
987874829 022   L $$a1940-5758
987874829 041   L $$aeng
987874829 24500 L $$aCode4Lib journal$$bC4LJ
987874829 2463  L $$aC4LJ
987874829 3620  L $$a1.2007 -
987874829 8564  L $$uhttp://journal.code4lib.org/

```

## MARC in JSON (MiJ)

[JSON](https://www.json.org/) is a common lightweight data-interchange format which is also easy for humans to read and write. "MARC in JSON" (MiJ) defines a standard how to store MARC data as JSON objects. 

Example "MARC in JSON" record:

```json
{
    "leader":"00251nas a2200121 c 4500",
    "fields":
    [
        {
            "001":"987874829"
        },
        {
            "007":"cr||||||||||||"
        },
        {
            "022":
            {
                "subfields":
                [
                    {
                        "a":"1940-5758"
                    }
                ],
                "ind1":" ",
                "ind2":" "
            }
        },
        {
            "041":
            {
                "subfields":
                [
                    {
                        "a":"eng"
                    }
                ],
                "ind1":" ",
                "ind2":" "
            }
        },
        {
            "245":
            {
                "subfields":
                [
                    {
                        "a":"Code4Lib journal"
                    },
                    {
                        "b":"C4LJ"
                    }
                ],
                "ind1":"0",
                "ind2":"0"
            }
        },
        {
            "246":
            {
                "subfields":
                [
                    {
                        "a":"C4LJ"
                    }
                ],
                "ind1":"3",
                "ind2":" "
            }
        },
        {
            "362":
            {
                "subfields":
                [
                    {
                        "a":"1.2007 -"
                    }
                ],
                "ind1":"0",
                "ind2":" "
            }
        },
        {
            "856":
            {
                "subfields":
                [
                    {
                        "u":"http://journal.code4lib.org/"
                    }
                ],
                "ind1":"4",
                "ind2":" "
            }
        }
    ]
}
```

## Catmandu JSON

The [Catmandu](http://librecat.org/Catmandu/) data toolkit converts MARC records internally as an "[array of arrays](https://metacpan.org/pod/Catmandu::Importer::MARC#EXAMPLE-ITEM)", which can be exported as JSON or YAML objects.

Example "Catmandu JSON" record:

```
{
    "_id": "987874829",
    "record": [
        [
            "LDR",
            " ",
            " ",
            "_",
            "00251nas a2200121 c 4500"
        ],
        [
            "001",
            " ",
            " ",
            "_",
            "987874829"
        ],
        [
            "007",
            " ",
            " ",
            "_",
            "cr||||||||||||"
        ],
        [
            "022",
            " ",
            " ",
            "a",
            "1940-5758"
        ],
        [
            "041",
            " ",
            " ",
            "a",
            "eng"
        ],
        [
            "245",
            "0",
            "0",
            "a",
            "Code4Lib journal",
            "b",
            "C4LJ"
        ],
        [
            "246",
            "3",
            " ",
            "a",
            "C4LJ"
        ],
        [
            "362",
            "0",
            " ",
            "a",
            "1.2007 -"
        ],
        [
            "856",
            "4",
            " ",
            "u",
            "http://journal.code4lib.org/"
        ]
    ]
}
```



