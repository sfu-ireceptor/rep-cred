FROM rocker/shiny:4.3.3

LABEL maintainer="ssnn"

RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y --fix-missing \
    gsfonts \
    imagemagick \
    libcurl4-openssl-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libglpk-dev \
    libgmp3-dev \
    libicu-dev \
    libmagick++-dev \
    libpng-dev \
    libssl-dev \
    libxml2-dev \
    make \
    pandoc \
    texlive-latex-base \
    texlive-fonts-recommended \
    texlive-fonts-extra \
    texlive-latex-extra \    
    xdg-utils \
    zlib1g-dev

ARG R_DEPS="c('devtools', \
              'BiocManager', 'tigger')"
RUN Rscript -e "install.packages(${R_DEPS}, dependencies=TRUE, clean=TRUE)"
RUN Rscript -e "BiocManager::install(c('Biostrings', 'GenomicAlignments', 'IRanges'))"
#RUN Rscript -e "devtools::install_github('LuciaRotger/CollessLike', ref='master', dependencies=TRUE)"
#RUN Rscript -e "devtools::install_github('matsengrp/sumrep', ref='master', dependencies=TRUE)"
RUN Rscript -e "devtools::install_github('airr-community/rep-cred', ref='master', dependencies=TRUE)"
#RUN Rscript -e "p<-Sys.getenv('PATH');Sys.setenv(PATH = paste(p, dirname(system.file('repcred.R', package='repcred')), sep = ':'))"
RUN Rscript -e "repcred<-system.file('repcred.R', package='repcred');file.copy(repcred,'/usr/local/bin/repcred')" \
    && chmod +x /usr/local/bin/repcred
WORKDIR /home
CMD Rscript -e "repcred::repcredWeb(launch.browser = F)"
