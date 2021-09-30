# Processing MARC 21

## ... with open source tools

"When MARC was created, the Beatles were a hot new group ..."

In 2002 Roy Tennant declared "[MARC Must Die](https://www.libraryjournal.com/?detailStory=marc-must-die)". Today the [MARC 21](https://www.loc.gov/marc/) format is still the workhorse of library metadata. Even our "Next Generation Library Systems" heavily rely on this standard from the ‘60s. Since we will continue to work with MARC 21 in the coming years, this tutorial will give an introduction to MARC 21 with the following topics: 

- [MARC 21](marc21.md)
    - Introduction
    - Record elements
- [Serializations](serializations.md) (MARCXML, MARCMaker, MARC-in-JSON, ALEPHSEQ) 
- [Tools](tools.md)
- [Validation](validation.md) of MARC 21 records and common errors 
- [Statistical analysis](statistics.md) of MARC 21 data sets 
- [Conversion](transformation.md) of MARC 21 records 
- [Metadata extraction](extract.md) from MARC 21 records 

This tutorial is intended for systems librarians, metadata librarians and data manager. For most of the tasks we will use command line tools like `yaz-marcdump`, `marcstats`, `marcvalidate` and `catmandu`. A [VirtualBox](https://www.virtualbox.org/) image containing most of the required tools can be downloaded at the [Catmandu](https://librecatproject.wordpress.com/get-catmandu/) project.

## Literature

- Avram (1975): *MARC; its History and implications.* <http://catalog.hathitrust.org/Record/002993527>
- Eversberg (1999): *Was sind und was sollen Bibliothekarische Datenformate* [urn:nbn:de:gbv:084-1103231323](https://nbn-resolving.org/urn%3Anbn%3Ade%3Agbv%3A084-11032313237)
- Tennant (2002): *MARC Must Die.* <https://www.libraryjournal.com/?detailStory=marc-must-die>
- Karen Smith-Yoshimura, Catherine Argus, Timothy J. Dickey, Chew Chiat Naun, Lisa Rowlinson de Oritz & Hugh Taylor (2010): *Implications of MARC Tag Usage on Library Metadata Practices* <https://www.oclc.org/content/dam/research/publications/library/2010/2010-06.pdf>
- Tennant (2013-2018): *MARC Usage in WorldCat* <http://roytennant.com/proto/groundtruthing/>
- Király (2019): *Validating 126 million MARC records* [10.1145/3322905.3322929](https://doi.org/10.1145/3322905.3322929)
- Király (2019): *Measuring Metadata Quality* [10.13140/RG.2.2.33177.77920](https://doi.org/10.13140/RG.2.2.33177.77920)
