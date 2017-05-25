FROM rocker/hadleyverse:latest

MAINTAINER Shrek Tan "shrektan@126.com"

# Winston Chang's shiny server code

RUN apt-get update && apt-get install -y -t unstable \
    sudo \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev/unstable \
    libxt-dev

# Download and install shiny server
RUN wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt)  && \
    wget --no-verbose "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb && \
    R -e "install.packages(c('shiny', 'rmarkdown'), repos='https://cran.rstudio.com/')" && \
    cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/

# Shrek's own working environment

# Install Database related apt
RUN apt-get update && apt-get install -y \
    libaio1

# CRAN version packages

# install2.r is an cmd of linux by import litter. If the package is not available in CRAN, it will stop.

RUN install2.r --error \
    assertthat \
    DBI \
    dendextend \
    dygraphs \
    DiagrammeR \
    extrafont \
    feather \
    forcats \
    forecast \
    ggthemes \
    infuser \
    jsonlite \
    knitr \
    leaflet \
    lubridate \
    mailR \
    openxlsx \
    pander \
    PerformanceAnalytics \
    PKI \
    R6 \
    packrat \
    RColorBrewer \
    RJDBC \
    RJSONIO \
    RPostgreSQL \
    rmarkdown \
    rvest \
    shinythemes \
    shinydashboard \
    showtext \
    stringr \
    testthat \
    tibble \
    tidyverse \
    treemap \
    V8 \
    viridisLite \
    xml2 \
    xtable \
    xts \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

# Github version packages
RUN R -e " \
devtools::install_github('rstudio/bookdown'); \
devtools::install_github('rstudio/d3heatmap'); \
devtools::install_github('Rdatatable/data.table'); \
devtools::install_github('gluc/data.tree', ref = 'dev'); \
devtools::install_github('hadley/dplyr'); \
devtools::install_github('rstudio/DT'); \
devtools::install_github('hadley/dtplyr'); \
devtools::install_github('rstudio/flexdashboard'); \
devtools::install_github('renkun-ken/formattable'); \
devtools::install_github('hadley/ggplot2'); \
devtools::install_github('slowkow/ggrepel'); \
devtools::install_github('jrnold/ggthemes'); \
devtools::install_github('Ather-Energy/ggTimeSeries'); \
devtools::install_github('ricardo-bion/ggradar'); \
devtools::install_github('jbkunst/highcharter'); \
devtools::install_github('ramnathv/htmlwidgets'); \
devtools::install_github('hadley/httr'); \
devtools::install_github('hrbrmstr/metricsgraphics'); \
devtools::install_github('hadley/purrr'); \
devtools::install_github('hadley/readr'); \
devtools::install_github('rstudio/rmarkdown'); \
devtools::install_github('imanuelcostigan/RSQLServer'); \
devtools::install_github('rstudio/shiny'); \
devtools::install_github('ebailey78/shinyBS', ref = 'shinyBS3'); \
devtools::install_github('daattali/shinyjs'); \
devtools::install_github('trestletech/shinyStore'); \
devtools::install_github('hrbrmstr/streamgraph'); \
devtools::install_github('hadley/svglite'); \
devtools::install_github('wilkox/treemapify'); \
devtools::install_github('joshuaulrich/xts'); \
devtools::install_github('trestletech/shinyStore');
"
# RUN R -e "install.packages('https://cran.rstudio.com/src/contrib/Archive/dplyr/dplyr_0.4.3.tar.gz', repos = NULL, type = 'source')"
# RUN R -e "devtools::install_github('sainathadapa/ggthemr')"

# RQuantLib which needs to install QuantLib & boost first
RUN apt-get update && apt-get install --fix-missing -y r-cran-rquantlib
RUN apt-get autoremove


# Make semi ENTRYPOINT
COPY rstudio-server.sh /usr/bin/rstudio-server.sh

EXPOSE 3838

COPY shiny-server.sh /usr/bin/shiny-server.sh

CMD ["/usr/bin/shiny-server.sh"]

# If you want to execute rstudio-server, you have to `docker exec shinyserver RUN /usr/bin/rstudio-server.sh after the container has been established.
