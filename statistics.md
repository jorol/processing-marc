# MARC statistics

## ... with marcstats.pl

To generate statistics for tags and subfield codes of "MARC (ISO 2709)" records use `marcstats.pl`.

```terminal
$ marcstats.pl loc.mrc
Statistics for 50 records
Tag     Rep.    Occ.,%
001             100.00
005             100.00
006               2.00
007              18.00
008             100.00
010              98.00
   a             98.00
   z              4.00
015               2.00
   2              2.00
   a              2.00
016               2.00
   2              2.00
   a              2.00
020              76.00
   a             76.00
   q              2.00
035     [Y]      48.00
   9    [Y]      18.00
   a    [Y]      30.00
...
```

## ... Catmandu

If you want generate statistics for other MARC serialization use  [Catmandu::Breaker](https://metacpan.org/pod/Catmandu::Breaker). First you need to "break" the MARC records into pieces. Afterwards you can calculate statistics for MARC tags and subfield codes. 

```terminal
$ catmandu convert MARC --type XML to Breaker --handler marc < loc.mrc.xml > loc.breaker
$ catmandu breaker loc.breaker
```

With option `--fields` you can calculate statistics for specific tags and subfield codes:

```terminal
$ catmandu breaker --fields 245a,020a loc.breaker
| name | count | zeros | zeros% | min | max | mean | variance | stdev | uniq~ | uniq% | entropy |
|------|-------|-------|--------|-----|-----|------|----------|-------|-------|-------|---------|
| #    | 50    |       |        |     |     |      |          |       |       |       |         |
| 245a | 50    | 0     | 0.0    | 1   | 1   | 1    | 0.0      | 0.0   | 45    | 90.1  | 5.4/5.6 |
| 020a | 52    | 12    | 24.0   | 0   | 4   | 1.04 | 0.8      | 0.9   | 51    | 98.2  | 5.3/6.0 |
```

Use option `-as` to specify a tabular output format (CSV, TSV, XLS(X)):

```terminal
$ catmandu breaker --as XLSX loc.breaker > loc.xlsx
```