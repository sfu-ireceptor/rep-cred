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

- PRJCA002413_HC3.tsv

PRJCA002413, repertoire_id = PRJCA002413-Healthy_Control_3-IGH on covid19-1.ireceptor.org

```
curl -k -s --data '{"filters":{"op":"=","content":{"field":"repertoire_id", "value"
:"PRJCA002413-Healthy_Control_3-IGH"}}, "format":"tsv", "size":5000}' https://covid19-1.ireceptor.org/airr/v1/rearrangement > PRJCA002413_HC3.tsv
```

rm -rf tmp/*
inst/repcred.R -r test_repertoires/PRJCA002413_HC3.tsv -o tmp -d TRUE

- PRJNA752617.tsv

```
curl -k -s --data '{"filters":{"op":"=","content":{"field":"repertoire_id", "value"
:"613b7f3eadf6058ccd849076"}}, "format":"tsv", "size":5000}' https://covid19-1.ireceptor.org/airr/v1/rearrangement > PRJNA752617.tsv
```

inst/repcred.R -r test_repertoires/PRJNA752617.tsv -o tmp -d TRUE

- PRJNA715378.tsv

```
curl -k -s --data '{"filters":{"op":"=","content":{"field":"repertoire_id", "value"
:"609e9b638a4ef25782e2104e"}}, "format":"tsv", "size":5000}' https://covid19-1.ireceptor.org/airr/v1/rearrangement > PRJNA715378.tsv
```

inst/repcred.R -r test_repertoires/PRJNA715378.tsv -o tmp -d TRUE

- 613b7f3eadf6058ccd849076.tsv

```
curl -k -s --data '{"filters":{"op":"=","content":{"field":"repertoire_id", "value"
:"613b7f3eadf6058ccd849076"}}, "format":"tsv", "size":5000}' https://covid19-1.ireceptor.org/airr/v1/rearrangement > 613b7f3eadf6058ccd849076.tsv
```

inst/repcred.R -r test_repertoires/613b7f3eadf6058ccd849076.tsv -o tmp -d TRUE


- 5f21e817e1adeb2edc126144.tsv

```
curl -k -s --data '{"filters":{"op":"=","content":{"field":"repertoire_id", "value"
:"5f21e817e1adeb2edc126144"}}, "format":"tsv", "size":5000}' https://covid19-1.ireceptor.org/airr/v1/rearrangement > 5f21e817e1adeb2edc126144.tsv
```

inst/repcred.R -r test_repertoires/5f21e817e1adeb2edc126144.tsv -o tmp -d TRUE


- 5efbc7325f94cb6215deecfc.tsv

```
curl -k -s --data '{"filters":{"op":"=","content":{"field":"repertoire_id", "value"
:"5efbc7325f94cb6215deecfc"}}, "format":"tsv", "size":5000}' https://covid19-1.ireceptor.org/airr/v1/rearrangement > 5efbc7325f94cb6215deecfc.tsv
```

inst/repcred.R -r test_repertoires/5efbc7325f94cb6215deecfc.tsv -o tmp -d TRUE

- 6079e74f20652127e6351593.tsv

```
curl -k -s --data '{"filters":{"op":"=","content":{"field":"repertoire_id", "value"
:"6079e74f20652127e6351593"}}, "format":"tsv", "size":5000}' https://covid19-1.ireceptor.org/airr/v1/rearrangement > 6079e74f20652127e6351593.tsv
```

inst/repcred.R -r test_repertoires/6079e74f20652127e6351593.tsv -o tmp -d TRUE

- 5edd817b7dd6ee5ee410772b.tsv

```
curl -k -s --data '{"filters":{"op":"=","content":{"field":"repertoire_id", "value"
:"5edd817b7dd6ee5ee410772b"}}, "format":"tsv", "size":5000}' https://covid19-2.ireceptor.org/airr/v1/rearrangement > 5edd817b7dd6ee5ee410772b.tsv
```

inst/repcred.R -r test_repertoires/5edd817b7dd6ee5ee410772b.tsv -o tmp -d TRUE