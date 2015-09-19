Docker for Shiny Server
=======================

This is a Dockerfile of my own working environment, which is based on rocker/shiny and rocker/hadleyverse. 

The image is available from [Docker Hub](https://hub.docker.com/r/shrektan/shiny/).

## Warning

I'm still working on it. Things will change!

## What's inside

- shiny server
- rstudio server
- database connection, including rsqlserver (using rjdbc), ROracle (with Oracle instant client), RODBC (with unixODBC)

## The goal

I will try to establish a clear and handy working process to establish the R working environment (maybe not suitable for everyone, but at least it would be kind of suitable for people who're working in the financial industry).

## Process

Currently, the image can run the shiny-server by default. If you need to run rstudio-server, you need one more line by manual.

Related to database connection, the `RJDBC` is ok. However, `ROracle` cannot be achieved through an automated building, because the Oracle instant client can't be downloaded automatically. I'll create a new branch with dockerfile to build the ROracle available image manually (probably need to download the Oracle instant client by hand and put in some folder). For `RODBC`, although I've installed the `unixODBC`, I still can't connect to database through `RODBC` and I have no idea at all. But I believe it's fixable as long as I have the time.

## Usage:

1. Pull the docker image via `docker pull shrektan/shiny`.
1. Run the code below:
```sh
docker run -d -p 80:3838 -p 8787:8787 \
  -v /Users/Flynn/Documents/RWD/shiny-apps/:/srv/shiny-server/ \
  -v /Users/Flynn/Documents/RWD/shinylog/:/var/log/ \
  --name shinyserver \
  shrektan/shiny
docker exec -d shinyserver sh /usr/bin/rstudio-server.sh
```
The last line of code is to run the rstudio-server. If you only need shiny-server, then just ignore it.

### How to connect the texlive

1. Pull the docker image cboettig/texlive, code `docker pull cboettig/texlive:latest`
1. Run a texlive container like this `docker run --name tex -v /usr/local/texlive cboettig/texlive`. Note, it usually takes about 30 seconds.
1. Run our image with a container linking.
```sh
docker run -d -p 80:3838 -p 8787:8787 \
  --volumes-from tex \
  -e PATH=$PATH:/usr/local/texlive/2014/bin/x86_64-linux/ \
  -v /Users/Flynn/Documents/RWD/shiny-apps/:/srv/shiny-server/ \
  -v /Users/Flynn/Documents/RWD/shinylog/:/var/log/ \
  --name shinyserver \
  shrektan/shiny
docker exec -d shinyserver sh /usr/bin/rstudio-server.sh
```

## Trademarks

Shiny and Shiny Server are registered trademarks of RStudio, Inc. The use of the trademarked terms Shiny and Shiny Server and the distribution of the Shiny Server through the images hosted on hub.docker.com has been granted by explicit permission of RStudio. Please review RStudio's trademark use policy and address inquiries about further distribution or other questions to permissions@rstudio.com.
