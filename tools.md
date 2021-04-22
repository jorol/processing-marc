# Software

## Install

For this tutorial we need some command-line tools to process MARC data. You can download a [VirtualBox](https://www.virtualbox.org/) image containing most of the required tools at the [Catmandu](https://librecatproject.wordpress.com/get-catmandu/) project. Please follow the installation instructions. Or install all tools on your own system. All necessary steps are described using a [Debian](https://www.debian.org/) based system. 

### Perl

Some of these tools require a [Perl](https://www.perl.org/) interpreter. I recommend to install a local Perl environment on your system using [`perlbrew`](https://perlbrew.pl/):

```terminal
# install perlbrew
$ \curl -L https://install.perlbrew.pl | bash
# edit .bashrc
$ echo -e '\nsource ~/perl5/perlbrew/etc/bashrc\n' >> ~/.bashrc
$ source ~/.bashrc
# initialize
$ perlbrew init
# see what versions are available
$ perlbrew available
# install a Perl version
$ perlbrew install -j 2 -n perl-5.28.2
# see installed versions
$ perlbrew list
# switch to an installation and set it as default
$ perlbrew switch perl-5.28.2
# install cpanm
$ perlbrew install-cpanm
```

### catmandu

[Catmandu](https://librecat.org/Catmandu) is data toolkit which can be used for [ETL](https://en.wikipedia.org/wiki/Extract,_transform,_load) processes. The project website provides some detailed [instructions](https://librecat.org/Catmandu/#installation) on how to install `catmandu` on different systems.

```terminal
# install dependencies
$ sudo apt install autoconf build-essential dconf-cli libexpat1-dev \
libgdbm-dev libssl-dev libxml2-dev libxslt1-dev libyaz-dev parallel perl-doc \
yaz zlib1g zlib1g-dev
# install Catmandu modules
$ cpanm Catmandu Catmandu::Breaker Catmandu::Exporter::Table \
Catmandu::Identifier Catmandu::Importer::getJSON Catmandu::MARC Catmandu::OAI \
Catmandu::PICA Catmandu::PNX Catmandu::RDF Catmandu::SRU Catmandu::Stat \
Catmandu::Template Catmandu::VIAF Catmandu::Validator::JSONSchema \
Catmandu::Wikidata Catmandu::XLS Catmandu::XSD Catmandu::Z3950
```

### marcvalidate

[MARC::Schema](https://metacpan.org/pod/MARC::Schema) provides the command-line utility `marcvalidate` to validate MARC records.

```terminal
$ cpanm MARC::Schema 
```

### marcstats.pl

[MARC::Record::Stats](https://metacpan.org/pod/MARC::Record::Stats) provides the command-line utility `marcstats.pl` to generate statistics for your MARC records.

```terminal
$ cpanm MARC::Record::Stats
```

### uconv

For [Unicode](https://home.unicode.org/) [normalizations](https://en.wikipedia.org/wiki/Unicode_equivalence) we need the command-line utility `uconv`.

```terminal
$ sudo apt install libicu-dev
```

### YAZ

[YAZ](https://www.indexdata.com/resources/software/yaz/) is a free open source toolkit from [Index Data](https://www.indexdata.com/), that includes command-line utility programs like `yaz-client` and `yaz-marcdump`.

```terminal
$ sudo apt install yaz
```

### xmllint

`xmllint` is a command-line tool to process XML data.

```terminal
$ sudo apt install libxml2-utils
```

### xsltproc

For transformation of XML data with XSL stylesheets we need a [XSLT](https://en.wikipedia.org/wiki/XSLT) processor.

```terminal
sudo apt install xsltproc
```

## Documenation

For more information of these tools you can read their `man` or `help` pages, e.g.:

```terminal
$ man yaz-marcdump
$ xmllint --help
```
