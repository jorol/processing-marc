#!/usr/bin/env bash

echo '### install software'
sudo apt install -y build-essential
sudo apt install -y curl
sudo apt install -y dkms
sudo apt install -y geany
sudo apt install -y gedit
sudo apt install -y git
sudo apt install -y gnome-icon-theme
sudo apt install -y language-pack-gnome-en
sudo apt install -y language-selector-gnome
sudo apt install -y libexpat1-dev
sudo apt install -y libgdbm-dev
sudo apt install -y libicu-dev
sudo apt install -y libssl-dev
sudo apt install -y libwrap0-dev
sudo apt install -y libxml2-dev
sudo apt install -y libxml2-utils
sudo apt install -y libxslt1-dev
sudo apt install -y libyaz-dev
sudo apt install -y nano
sudo apt install -y perl-doc
sudo apt install -y cpanminus
sudo apt install -y sqlite3
sudo apt install -y tilix
sudo apt install -y virtualbox-guest-utils
sudo apt install -y virtualbox-guest-x11
sudo apt install -y xsltproc
sudo apt install -y yaz
sudo apt install -y zlib1g
sudo apt install -y zlib1g-dev

echo '### install local Perl environment ###'
# install perlbrew
curl -L https://install.perlbrew.pl | bash
# edit .bashrc
echo -e '\nsource ~/perl5/perlbrew/etc/bashrc\n' >> ~/.bashrc
source ~/perl5/perlbrew/etc/bashrc
# initialize
perlbrew init
# install a Perl version
perlbrew install -j 2 -n perl-5.30.3
# switch to an installation and set it as default
perlbrew switch perl-5.30.3
# install cpanm
perlbrew install-cpanm

echo '### install Perl modules ###'
# fix version dependencies
cpanm XML::LibXML@2.0201
cpanm -f LaTeX::ToUnicode@0.11

# install modules
cpanm Catmandu Catmandu::AlephX Catmandu::BibTeX Catmandu::Breaker Catmandu::Cmd::repl Catmandu::Exporter::Table Catmandu::Exporter::Template Catmandu::Fix::cmd Catmandu::Fix::Date Catmandu::Fix::XML Catmandu::Identifier Catmandu::Importer::getJSON Catmandu::Importer::MODS Catmandu::LIDO Catmandu::MAB2 Catmandu::MARC Catmandu::MODS Catmandu::OAI Catmandu::OCLC Catmandu::PICA Catmandu::PNX Catmandu::RDF Catmandu::SRU Catmandu::Stat Catmandu::Template Catmandu::Validator::JSONSchema Catmandu::Wikidata Catmandu::XLS Catmandu::XML Catmandu::XSD Catmandu::Z3950 MARC::Record::Stats MARC::Schema
