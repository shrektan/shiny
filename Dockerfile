FROM rocker/verse:latest

MAINTAINER Shrek Tan "shrektan@126.com"

# RQuantLib which needs to install QuantLib & boost first
# RUN apt-get update && apt-get install --fix-missing  -y --no-install-recommends r-cran-rquantlib
# RUN apt-get autoremove

# Winston Chang's shiny server code

# Install dependencies and Download and install shiny server
RUN apt-get update && apt-get install -y --no-install-recommends \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libxt-dev && \
    wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt)  && \
    wget --no-verbose "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb && \
    R -e "install.packages(c('shiny', 'rmarkdown'), repos='https://cran.rstudio.com/')" && \
    cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/ && \
    rm -rf /var/lib/apt/lists/*

# Shrek's own working environment

# Install Database related apt
RUN apt-get update && apt-get install -y --no-install-recommends \
    libaio1

# CRAN version packages

# install2.r is an cmd of linux by import litter. If the package is not available in CRAN, it will stop.

RUN install2.r --error \
    assertthat \
    bookdown \
    blogdown \
    covr \
    d3heatmap \
    DBI \
    data.tree \
    dendextend \
    debugme \
    dplyr \
    dtplyr \
    drat \
    dygraphs \
    DiagrammeR \
    extrafont \
    feather \
    flexdashboard \
    formattable \
    forcats \
    forecast \
    fs \
    fst \
    ggplot2 \
    ggthemes \
    ggrepel \
    ggpubr \
    highcharter \
    htmlwidgets \
    httr \
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
    packrat \
    pkgconfig \
    pool \
    progress \
    purrr \
    R6 \
    RcppArmadillo \
    RColorBrewer \
    readr \
    RJDBC \
    RJSONIO \
    RPostgreSQL \
    RcppArmadillo \
    RSQLServer \
    rmarkdown \
    rlang \
    rvest \
    shiny \
    shinyjs \
    shinythemes \
    shinydashboard \
    showtext \
    stringr \
    svglite \
    testthat \
    tibble \
    tidyverse \
    treemap \
    usethis \
    V8 \
    viridisLite \
    whoami \
    withr \
    writexl \
    xml2 \
    xtable \
    xts \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

# Github version packages
RUN R -e " \
devtools::install_github('Rdatatable/data.table'); \
devtools::install_github('rstudio/DT'); \
devtools::install_github('Ather-Energy/ggTimeSeries'); \
devtools::install_github('ricardo-bion/ggradar'); \
devtools::install_github('hrbrmstr/metricsgraphics'); \
devtools::install_github('ebailey78/shinyBS', ref = 'shinyBS3'); \
devtools::install_github('trestletech/shinyStore'); \
devtools::install_github('hrbrmstr/streamgraph'); \
devtools::install_github('wilkox/treemapify'); \
"
# RUN R -e "install.packages('https://cran.rstudio.com/src/contrib/Archive/dplyr/dplyr_0.4.3.tar.gz', repos = NULL, type = 'source')"
# RUN R -e "devtools::install_github('sainathadapa/ggthemr')"


# Make semi ENTRYPOINT
# COPY rstudio-server.sh /usr/bin/rstudio-server.sh

EXPOSE 3838

COPY shiny-server.sh /usr/bin/shiny-server.sh

CMD ["/usr/bin/shiny-server.sh"]

# If you want to execute rstudio-server, you have to `docker exec shinyserver RUN /usr/bin/rstudio-server.sh after the container has been established.
