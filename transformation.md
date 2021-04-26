# Transformation of MARC data

## ... with yaz-marcdump

`yaz-marcdump` can be used to tranform MARC data between different serializations. Use options `-i` and `-o` to specfiy the input and output formats.

"MARC (ISO 2709)" to "MARC XML":

```terminal
$ yaz-marcdump -i marc -o marcxml code4lib.mrc > code4lib.xml
```

"MARC (ISO 2709)" to "Turbomarc":

```terminal
$ yaz-marcdump -i marc -o turbomarc code4lib.mrc > code4lib.turbo.xml
```

"MARC (ISO 2709)" to "MARC Line":

```terminal
$ yaz-marcdump -i marc -o line code4lib.mrc > code4lib.line
```

"MARC XML" to "MARC-in-JSON":

```terminal
$ yaz-marcdump -i marcxml -o json code4lib.mrc.xml > code4lib.json
```

## ... with Catmandu

The command-line interface of the Catmandu toolkit also offers several tranformations of MARC data. The default MARC serialization is "MARC (ISO 2709)".

"MARC (ISO 2709)" to "MARC XML":

```terminal
$ catmandu convert MARC to MARC --type XML < code4lib.mrc > code4lib.xml
```

"MARC XML" to "MARC (ISO 2709)":

```terminal
$ catmandu convert MARC --type XML to MARC < code4lib.xml > code4lib.mrc
```

"MARC (ISO 2709)" to "MARCMaker":

```terminal
$ catmandu convert MARC to MARC --type MARCMaker < code4lib.mrc > code4lib.mrk
```

"MARC XML" to "MARC-in-JSON":

```terminal
$ catmandu convert MARC --type XML to MARC --type MiJ < code4lib.xml > code4lib.json
```

"MARC XML" to YAML:

```terminal
$ catmandu convert MARC to YAML < code4lib.mrc > code4lib.yml
```

The [Catmandu::Breaker](https://metacpan.org/pod/Catmandu::Breaker) module "breaks" data into smaller components and exports them line by line:

```terminal
$ catmandu convert MARC to Breaker --handler marc < code4lib.mrc
987874829   LDR 01031nas a2200337 c 4500
987874829   001 987874829
987874829   003 DE-101
987874829   005 20200306093601.0
987874829   007 cr||||||||||||
987874829   008 080311c20079999|||u||p|o ||| 0||||1eng c
987874829   0162    DE-101
987874829   016a    987874829
987874829   0162    DE-600
987874829   016a    2415107-5
987874829   022a    1940-5758
987874829   035a    (DE-599)ZDB2415107-5
...
```

You can process this output with other command-line utilities like `grep`, `sort` and `uniq`. For example, to extract all ISBN from a MARC data sets, we can build a command-line [pipeline](https://en.wikipedia.org/wiki/Pipeline_(Unix)) like this:

```terminal
$ catmandu convert MARC to Breaker --handler marc < loc.mrc \
| grep -P '\t020a' | cut -f 3 | grep -oP '^[\dX]+' | sort | uniq -c
      1 0072123397
      1 0130284181
      1 0201422190
      1 0470176431
      2 0596002270
...
```


With Catmandu you can export data to generic data formats like CSV, JSON, TSV, XLSX and YAML. MARC serializations are "complex/nested data structures" which cannot be stored in flat data structures like tables. 

You can export MARC records to nested formats like JSON and YAML:

```
$ catmandu convert MARC to YAML < code4lib.mrc
$ catmandu convert MARC to JSON < code4lib.mrc
```


This will **not** work:

```
$ catmandu convert MARC to CSV < code4lib.mrc
$ catmandu convert MARC to TSV < code4lib.mrc
$ catmandu convert MARC to XLSX < code4lib.mrc
```

You need to use "[Catmandu::Fix](https://metacpan.org/pod/Catmandu::Fix)" to extract and map your data to a tabular data structure:


```
$ catmandu convert MARC to CSV \
--fix 'marc_map(245abc,dc_title,join:" ");retain_field(dc_title)' \
< code4lib.mrc
```

## ... with XLST

If you want transform MARC records to other formats, you have to map MARC (sub)fields to corresponding fields of the other format. The Libary of Congress provides several crosswalks:

* [MARC to MODS](https://www.loc.gov/standards/mods/mods-mapping.html)
* [MODS to MARC](https://www.loc.gov/standards/mods/v3/mods2marc-mapping.html)
* [MARC to Dublin Core](https://www.loc.gov/marc/marc2dc.html)
* [Dublin Core to MARC](https://www.loc.gov/marc/dccross.html)
* [ONIX to MARC](https://www.loc.gov/marc/onix2marc.html)


Based on these crosswalks the Library of Congress published several [XLS stylesheets](https://www.loc.gov/standards/marcxml/#stylesheets), which can be used with a XSLT processor to transform "MARC XML" records to other formats like BIBFRAME, HTML, MODS, OAI-DC and RDF. 

"MARC XML" to MODS:

```terminal
$ xsltproc MARC21slim2MODS3-7.xsl loc.mrc.xml > loc.mods.xml
```

"MARC XML" to HTML:

```terminal
$ xsltproc MARC21slim2HTML.xsl loc.mrc.xml > loc.html
```

"MARC XML" to "OAI-DC":

```terminal
$ xsltproc MARC21slim2OAIDC.xsl loc.mrc.xml > loc.oaidc.xml
```

"MARC XML" to "RDF-DC":

```terminal
$ xsltproc MARC21slim2RDFDC.xsl loc.mrc.xml > loc.rdfdc.xml
```

"MARC XML" to "[BIBFRAME](https://github.com/lcnetdev/marc2bibframe2)":

```terminal
$ xsltproc bibframe-xsl/marc2bibframe2.xsl loc.mrc.xml > loc.bibframe.xml
```


