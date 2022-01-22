[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)]()
[![Documentation Status](https://readthedocs.org/projects/rep-cred/badge/?version=latest)](https://rep-cred.readthedocs.io/en/latest/?badge=latest)
[![Build Status](https://travis-ci.org/airr-community/rep-cred.svg?branch=master)](https://travis-ci.org/airr-community/rep-cred)


# Installation

## Pre-requisites

Repcred uses two packages that should be installed from their github pages:  [CollessLike](https://github.com/LuciaRotger/CollessLike)
and
[Sumrep](https://github.com/matsengrp/sumrep). They must be installed in order. The easiest way is to use devtools:  

```
    library(devtools)  
    install_github("LuciaRotger/CollessLike")  
    install_github("matsengrp/sumrep"  
```

Repcred also requires a recent version of [pandoc](https://pandoc.org). This is installed with Rstudio and the easiest approach is to check that you are using a recent version, although other installation methods are described in the [documentation](https://bookdown.org/yihui/rmarkdown-cookbook/install-pandoc.html).
 
Finally, Repcred requires the following packages, which need, for the time being, to be installed manually using install.packages():

```
    reticulate  
    spgs  
    kableExtra  
```

## Installing Repcred

Once pre-requisites are installed, repdred can be installed from github:

```
    install_github('airr-community/rep-cred')
```

# Running Repcred

Repcred can be started from an R prompt as follows:

```
    library(repcred)   
    repcredWeb()  
```

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/airr-community/rep-cred/master?urlpath=shiny/binder/)
