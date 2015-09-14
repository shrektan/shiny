FROM rocker/hadleyverse:latest

MAINTAINER Shrek Tan "shrektan@126.com"

# Winston Chang's shiny server code

RUN apt-get update && apt-get install -y \
    sudo \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev/unstable \
    libxt-dev

# Download and install libssl 0.9.8
RUN wget --no-verbose http://ftp.us.debian.org/debian/pool/main/o/openssl/libssl0.9.8_0.9.8o-4squeeze14_amd64.deb && \
    dpkg -i libssl0.9.8_0.9.8o-4squeeze14_amd64.deb && \
    rm -f libssl0.9.8_0.9.8o-4squeeze14_amd64.deb

# Download and install shiny server
RUN wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt)  && \
    wget --no-verbose "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb

RUN R -e "install.packages(c('shiny', 'rmarkdown'), repos='https://cran.rstudio.com/')"

RUN cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/

EXPOSE 3838

COPY shiny-server.sh /usr/bin/shiny-server.sh

# Shrek's own working environment

# CRAN version packages

# install2.r is an cmd of linux by import litter. If the package is not available in CRAN, it will stop.

RUN install2.r --error \
    ggthemes \
    RColorBrewer \
    knitr \
    xtable \
    rmarkdown \
    lubridate \
    stringr \
    openxlsx \
    xts \
    PerformanceAnalytics \
    shiny \
    shinythemes \
    shinydashboard \
    dygraphs \
    DiagrammeR \
    R6 \
    V8 \
    leaflet \
    RJDBC \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

# Github version packages
RUN R -e "devtools::install_github('Rdatatable/data.table')"
RUN R -e "devtools::install_github('daattali/shinyjs')"
RUN R -e "devtools::install_github('rstudio/DT')"
RUN R -e "devtools::install_github('ebailey78/shinyBS', ref = 'shinyBS3')"
RUN R -e "devtools::install_github('cttobin/ggthemr')"
RUN R -e "devtools::install_github('imanuelcostigan/RSQLServer')"

# Make semi ENTRYPOINT

CMD ["/usr/bin/shiny-server.sh"]
