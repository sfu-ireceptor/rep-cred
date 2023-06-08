[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)]()
[![Documentation Status](https://readthedocs.org/projects/rep-cred/badge/?version=latest)](https://rep-cred.readthedocs.io/en/latest/?badge=latest)
[![Build Status](https://travis-ci.org/airr-community/rep-cred.svg?branch=master)](https://travis-ci.org/airr-community/rep-cred)


# Installation

## Pre-requisites

Repcred requires a recent version of [pandoc](https://pandoc.org). This is installed with Rstudio and the easiest approach is to check that you are using a recent version, although other installation methods are described in the [documentation](https://bookdown.org/yihui/rmarkdown-cookbook/install-pandoc.html).
 
## Installing Repcred

Repdred can be installed from github:

```
devtools::install_github('airr-community/rep-cred')
```

# Running Repcred

## Docker - GUI

Pull the container:

```
docker pull airrc/rep-cred:latest
```

To launch the shiny application use the command below. Then open in your browser
` http://localhost:3838`. 

```
docker run --rm -ti --user shiny -p 3838:3838 airrc/rep-cred:latest
```

If you are using linux, you may need to use the command line

```
docker run --rm --network host -ti --user shiny -p 3838:3838 airrc/rep-cred:latest
```

To open a terminal inside the container use:

```
docker run --rm --user shiny -p 3838:3838 airrc/rep-cred:latest bash
```

## Docker - command line

Pull the container:

```
docker pull airrc/rep-cred:latest
```

Get example data:

```
wget https://raw.githubusercontent.com/airr-community/rep-cred/master/inst/extdata/ExampleDb.tsv
```

Run `repcred`:

```
docker run --rm -v $(pwd):/home:z airrc/rep-cred:latest repcred -r ExampleDb.tsv -o repcred-report
```


## Local - GUI

Repcred can be started from an R prompt as follows:

```
library(repcred)   
repcredWeb()  
```

## Binder

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/airr-community/rep-cred/master?urlpath=shiny/binder/)
