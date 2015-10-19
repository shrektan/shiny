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

# Install Database related apt
RUN apt-get update && apt-get install -y \
    libaio1 \
    unixODBC-dev

# CRAN version packages

# install2.r is an cmd of linux by import litter. If the package is not available in CRAN, it will stop.

RUN install2.r --error \
    dygraphs \
    DiagrammeR \
    ggthemes \
    jsonlite \
    knitr \
    leaflet \
    lubridate \
    mailR \
    openxlsx \
    PerformanceAnalytics \
    PKI \
    R6 \
    RColorBrewer \
    RJDBC \
    RJSONIO \
    rmarkdown \
    shiny \
    shinythemes \
    shinydashboard \
    stringr \
    RODBC \
    V8 \
    xtable \
    xts \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

# Github version packages
RUN R -e "devtools::install_github('Rdatatable/data.table')"
RUN R -e "devtools::install_github('rstudio/DT')"
RUN R -e "devtools::install_github('cttobin/ggthemr')"
RUN R -e "devtools::install_github('hadley/httr')"
RUN R -e "devtools::install_github('hadley/purrr')"
RUN R -e "devtools::install_github('hadley/readr')"
RUN R -e "devtools::install_github('imanuelcostigan/RSQLServer')"
RUN R -e "devtools::install_github('ebailey78/shinyBS', ref = 'shinyBS3')"
RUN R -e "devtools::install_github('daattali/shinyjs')"
RUN R -e "devtools::install_github('trestletech/shinyStore')"

# Install Oracle
export OCI_LIB=/scratch/instantclient
export LD_LIBRARY_PATH=/scratch/instantclient:$LD_LIBRARY_PATH
export TNS_ADMIN=/scratch/instantclient/NETWORK/admin/
export NLS_LANG="SIMPLIFIED CHINESE_CHINA.ZHS16GBK"

mkdir /scratch
mkdir /scratch/instantclient

sudo cp -R /srv/shiny-server/pkgs-debian/instantclient_12_1/* /scratch/instantclient
cd /scratch/instantclient/
ln -s libclntsh.so.12.1 libclntsh.so

R CMD INSTALL /srv/shiny-server/pkgs-R/ROracle_1.2-1.tar.gz

# Make semi ENTRYPOINT
COPY rstudio-server.sh /usr/bin/rstudio-server.sh

CMD ["/usr/bin/shiny-server.sh"]

# If you want to execute rstudio-server, you have to `docker exec shinyserver RUN /usr/bin/rstudio-server.sh after the container has been established.
