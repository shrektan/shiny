FROM rocker/hadleyverse:latest

MAINTAINER Shrek Tan "shrektan@126.com"

# Winston Chang's shiny server code

RUN apt-get update && apt-get install -y -t unstable \
    gdebi-core \
    libcurl4-gnutls-dev

# Download and install shiny server
RUN wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt)  && \
    wget --no-verbose "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb

# Shrek's own working environment

# Install Database related apt
RUN apt-get update && apt-get install -y \
    libaio1

# CRAN version packages

# install2.r is an cmd of linux by import litter. If the package is not available in CRAN, it will stop.

RUN install2.r --error \
    assertthat \
    dendextend \
    dygraphs \
    DiagrammeR \
    extrafont \
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
    RColorBrewer \
    RJDBC \
    RJSONIO \
    rmarkdown \
    shinythemes \
    shinydashboard \
    showtext \
    stringr \
    V8 \
    xtable \
    xts \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

# Github version packages
RUN R -e "devtools::install_github('rstudio/d3heatmap')"
RUN R -e "devtools::install_github('Rdatatable/data.table')"
RUN R -e "devtools::install_github('gluc/data.tree', ref = 'dev')"
# RUN R -e "devtools::install_github('hadley/dplyr')"
RUN R -e "devtools::install_github('rstudio/DT')"
RUN R -e "devtools::install_github('renkun-ken/formattable')"
RUN R -e "devtools::install_github('hadley/ggplot2')"
RUN R -e "devtools::install_github('slowkow/ggrepel')"
RUN R -e "devtools::install_github('jrnold/ggthemes')"
RUN R -e "devtools::install_github('sainathadapa/ggthemr')"
RUN R -e "devtools::install_github('Ather-Energy/ggTimeSeries')"
RUN R -e "devtools::install_github('ricardo-bion/ggradar')"
RUN R -e "devtools::install_github('jbkunst/highcharter')"
RUN R -e "devtools::install_github('ramnathv/htmlwidgets')"
RUN R -e "devtools::install_github('hadley/httr')"
RUN R -e "devtools::install_github('hrbrmstr/metricsgraphics')"
RUN R -e "devtools::install_github('hadley/purrr')"
RUN R -e "devtools::install_github('hadley/readr')"
RUN R -e "devtools::install_github('imanuelcostigan/RSQLServer')"
RUN R -e "devtools::install_github('rstudio/shiny')"
RUN R -e "devtools::install_github('ebailey78/shinyBS', ref = 'shinyBS3')"
RUN R -e "devtools::install_github('daattali/shinyjs')"
RUN R -e "devtools::install_github('trestletech/shinyStore')"
RUN R -e "devtools::install_github('hrbrmstr/streamgraph')"
RUN R -e "devtools::install_github('hadley/svglite')"

# Make semi ENTRYPOINT
COPY rstudio-server.sh /usr/bin/rstudio-server.sh

RUN cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/

EXPOSE 3838

COPY shiny-server.sh /usr/bin/shiny-server.sh

CMD ["/usr/bin/shiny-server.sh"]

# If you want to execute rstudio-server, you have to `docker exec shinyserver RUN /usr/bin/rstudio-server.sh after the container has been established.
