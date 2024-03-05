Test repertoires
----------------

- airr-covid-19.tsv

```
curl -k -s --data '{"filters":{"op":"=","content":{"field":"repertoire_id", "value"
:"615623b66d7bc19b84b9ae54"}}, "format":"tsv"}' https://covid19-1.ireceptor.org/airr/v1/rearrangement > airr-covid-19.tsv
```

- PRJNA381394_12.tsv

5000 records from PRJNA381394, subject B00_CLL_05_10x, repertoire_id = 12, ipa5.ireceptor.org.

```
curl -k -s --data '{"filters":{"op":"=","content":{"field":"repertoire_id", "value"
:"12"}}, "format":"tsv", "size":5000}' https://ipa5.ireceptor.org/airr/v1/rearrangement > PRJNA381394_12.tsv
```
