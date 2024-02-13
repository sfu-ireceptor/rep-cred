Test repertoires
----------------

- airr-covid-19.tsv

```
curl -k -s --data '{"filters":{"op":"=","content":{"field":"repertoire_id", "value"
:"615623b66d7bc19b84b9ae54"}}, "format":"tsv"}' https://covid19-1.ireceptor.org/airr/v1/rearrangement > airr-covid-19.tsv
```
