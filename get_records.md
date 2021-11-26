# Get MARC 21 data

## Open Data

Several libraries and library networks publish their data as "[open data](https://en.wikipedia.org/wiki/Open_data)". 

[Péter Király](https://github.com/pkiraly) created a list of international open MARC 21 data sets at &lt;https://github.com/pkiraly/metadata-qa-marc#datasources&gt;.

The Internet Archive's [Open Library](http://openlibrary.org/) project is making thousands of library records freely available for anyone's use, see &lt;https://archive.org/details/ol_data&gt;.

You can download the data sets via the command line, e.g.:

```bash
$ wget http://ered.library.upenn.edu/data/opendata/pau.zip
$ unzip pau.zip
```

## API

Many libraries offer MARC 21 data via public [APIs](https://en.wikipedia.org/wiki/API) like Z39.50, SRU, OAI.

### Z39.50

Z39.50 is a standard ([ANSI/NISO Z39.50-2003](https://www.loc.gov/z3950/agency/Z39-50-2003.pdf)) that defines a client/server based service and protocol for information retrieval. Like MARC 21 Z39.50 has a quite long history ([Lynch, 1997](http://www.dlib.org/dlib/april97/04lynch.html)) and is maintained by Library of Congress.

Many libraries offer access to their Online Public Access Catalogues (OAPC) via Z39.50 servers, e.g. [Library of Congress](https://www.loc.gov/z3950/lcserver.html) or [KOBV](https://www.kobv.de/services/recherche/z39-50/). 

To retrieve data from Z39.50 servers you need a client software like `yaz-client` from [Index Data](https://www.indexdata.com/), which is part of the free open source toolkit "[YAZ](https://www.indexdata.com/resources/software/yaz/)":

```terminal
# open client
$ yaz-client
# connect to database
Z> open lx2.loc.gov/LCDB
# set format to MARC
Z> format 1.2.840.10003.5.10
# set element set
Z> element F
# append retrieved records to file
Z> set_marcdump loc.mrc
# find record for subject
Z> find @attr 5=100 @attr 1=21 "Perl"
# get first 50 records
Z> show 1+50
# close client
Z> exit
```


The Catmandu toolkit provides a Z39.50 client "[Catmandu::Importer::Z3950](https://metacpan.org/pod/Catmandu::Importer::Z3950)":

```terminal
$ catmandu convert -v Z3950 \
--host z3950.kobv.de \
--port 210 \
--databaseName k2 \
--preferredRecordSyntax usmarc \
--queryType PQF \
--query '@attr 1=1016 code4lib' \
--handler USMARC \
to MARC > code4lib.mrc
```

### SRU

[SRU](https://www.loc.gov/standards/sru/) (Search/Retrieve via URL) is another standard protocol for information retrival. It uses HTTP as application layer protocol and XML for data serialization. Search queries are expressed with [CQL](https://www.loc.gov/standards/sru/cql/index.html) (Contextual Query Language), a formal language for representing queries.

You can use the `yaz-client` to search and retrive data from a SRU server:

```terminal
# open client
$ yaz-client
# connect to database
Z> open http://sru.k10plus.de/gvk
# append retrieved records to file
Z> set_marcdump gvk.mrc.xml
# find record for subject
Z> find pica.sw=Perl
# get first 50 records
Z> show 1+50
# close client
Z> exit
```


The Catmandu toolkit also provides a SRU client "[Catmandu::Importer::SRU](https://metacpan.org/pod/Catmandu::Importer::SRU)":

```terminal
$ catmandu convert -v SRU \
--base https://services.dnb.de/sru/zdb \
--recordSchema MARC21-xml \
--query 'dnb.iss = 1940-5758' \
--parser marcxml \
to MARC --type XML > code4lib.xml
```

### OAI-PMH

[OAI-PMH](https://www.openarchives.org/OAI/openarchivesprotocol.html) (Open Archives Initiative Protocol for Metadata Harvesting) is a protocol for metadata replication and distribution. _Data providers_ host metadata records and their changes over time, so _service providers_ can harvest them. As SRU it uses HTTP as application layer protocol and XML for data serialization.  

The Catmandu toolkit provides an OAI-PMH _harvester_ client "[Catmandu::Importer::OAI](https://metacpan.org/pod/Catmandu::Importer::SRU)":


```terminal
$ catmandu convert -v OAI \
--url https://lib.ugent.be/oai \
--metadataPrefix marcxml \
--from 2021-02-01 \
--until 2021-02-01 \
--handler marcxml \
to MARC > gent.mrc
```
