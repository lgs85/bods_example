# bods_example

Analysis of an example submission to the beneficial ownership data standard

1. Summarise the BODS example, focussing on the `beneficialOwnershipOrControl` field, and the `identifiers` array

```
Rscript R/bods_summarise.R data/Chaarat-Kapan-2021-02-19.json
```

2. Try the same thing using a python script (just trying out using python for json)

```
python3 python/bods_summarise.py data/Chaarat-Kapan-2021-02-19.json
```


3. Make a network diagram showing the beneficial ownership structures

```
Rscript R/bods_net.R data/Chaarat-Kapan-2021-02-19.json plots/Chaarat-Kapan-2021-02-19.pdf
``` 