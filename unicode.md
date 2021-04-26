# Unicode

## MARC-8 and Unicode

"MARC (ISO 2709)" records could be encoded in two different character coding schemes: [MARC-8](https://www.loc.gov/marc/specifications/specchartables.html) or [UCS/Unicode](https://www.iso.org/standard/69119.html).

Use `yaz-marcdump` to convert the encoding of MARC records. Specify the encoding with options `-f` and `-t`. With option `-l` you can set the character coding scheme in the MARC leader position 09.

```
$ yaz-marcdump -f MARC-8 -t UTF-8 -o marc -l 9=97 marc21.raw > marc21.utf8.raw
```

A conversion from UTF-8 to MARC-8 is not recommended, because it could be "lossy".

## Unicode normalization

Unicode provides single code points for many characters that could be viewed  as combinations of two or more characters, e.g. German umlauts:

| Composed/NFC | Decomposed/NFD |
|----------|------------|
| ä ([Latin Small Letter A with Diaeresis](https://www.compart.com/en/unicode/U+00E4) U+00E4) | a ([Latin Small Letter A](https://www.compart.com/en/unicode/U+0061) U+0061) + ◌̈ ([Combining Diaeresis](https://www.compart.com/en/unicode/U+0308) U+0308) |

With the command-line utility `uconv` you can transliterate data between different Unicode [normalization forms](https://unicode.org/reports/tr15/#Norm_Forms): 

```
$ uconv -x NFC marc21.nfd.xml > marc21.nfc.xml
$ uconv -x NFD marc21.nfc.xml > marc21.nfd.xml
```

You should only normalize "MARC XML" data, as the normalization of "MARC (ISO 2709)" would result in corrupted records, due to changed field length.  



