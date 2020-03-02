About
=====

|Lifecycle: experimental|

Ways to use:

-  In an R session: use ``repcredWeb()`` to launch a browser.

-  From the command line: Rscript inst/repcred.R -r
   inst/extdata/ExampleDb.tsv -o tmp_repcred

-  In RStudio, create a new project with the report code, to be able to
   customize it: File > New Project > New directory > Repertoire
   Credibility Project

|Binder|

Dependencies
------------

| **Depends:** shiny
| **Imports:** airr, bookdown, dplyr, knitr, plotly, rmarkdown, stringr,
  sumrep
| **Suggests:** testthat
| **Extends:** FALSE

Authors
-------

| `Susanna Marquez <mailto:susanna.marquez@yale.edu>`__ (aut, cre)
| AIRR Community (cph)

.. |Lifecycle: experimental| image:: https://img.shields.io/badge/lifecycle-experimental-orange.svg
   :target: 
.. |Binder| image:: https://mybinder.org/badge_logo.svg
   :target: https://mybinder.org/v2/gh/airr-community/rep-cred/master?urlpath=shiny/binder/
