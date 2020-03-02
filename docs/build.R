library(markr) #devtools::install_bitbucket("javh/markr@default")

library(repcred)

doc_path <- "./docs"
build_mkdocs(".", doc_path=doc_path, style="sphinx", yaml=F)
run_pandoc(doc_path, format="rst", delete=T)

