# This Repo / Docker Image Has Been Archived

Please use [shrektan/rdocker4shinyserver](https://github.com/shrektan/rdocker) instead.


Docker for Shiny Server
=======================

[![](https://images.microbadger.com/badges/image/shrektan/shiny.svg)](https://microbadger.com/images/shrektan/shiny "Get your own image badge on microbadger.com")

It's an antomated build docker image from [Github shrektan/shiny](https://github.com/shrektan/shiny).

This is a Dockerfile of my own working environment, which is based on rocker/shiny and rocker/hadleyverse. 

The image is available from [Docker Hub](https://hub.docker.com/r/shrektan/shiny/).

## Warning

I'm still working on it. Things will change!

## What's inside

- Shiny Server
- Rstudio Server
- Database connection, currently only `RSQLServer`. For `ROracle` (using Oracle instant client), you have to do it manually, because I don't have the time to figure out how to download the instant client automatically (you can send me an email if you don't know how to do it, my email is shrektan@126.com). 


## The goal

I will try to establish a clear and handy working process to establish the R working environment (maybe not suitable for everyone, but at least it would be kind of suitable for people who're working in the financial industry).

## Process

Currently, the image can run the shiny-server by default. If you need to run rstudio-server, you need one more line by manual.
```sh
docker run -d -p 80:3838 \
    -v /srv/shinyapps/:/srv/shiny-server/ \
    -v /srv/shinylog/:/var/log/shiny-server/ \
    rocker/shiny
```

Related to database connection, the `RJDBC` is ok. However, `ROracle` cannot be achieved through an automated building, because the Oracle instant client can't be downloaded automatically. I'll create a new branch with dockerfile to build the ROracle available image manually (probably need to download the Oracle instant client by hand and put in some folder). For `RODBC`, although I've installed the `unixODBC`, I still can't connect to database through `RODBC` and I have no idea at all. But I believe it's fixable as long as I have the time.

## Usage:

1. Pull the docker image via `docker pull shrektan/shiny`.
1. Run the code below:  
```
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
```
docker run -d -p 80:3838 -p 8787:8787 \
  --volumes-from tex \
  -e PATH=$PATH:/usr/local/texlive/2014/bin/x86_64-linux/ \
  -v /Users/Flynn/Documents/RWD/shiny-apps/:/srv/shiny-server/ \
  -v /Users/Flynn/Documents/RWD/shinylog/:/var/log/ \
  --name shinyserver \
  shrektan/shiny
docker exec -d shinyserver sh /usr/bin/rstudio-server.sh
```
1. modify the `PATH` environment variable in shiny (I haven't figured out how to avoid this)
```
sudo vi /etc/profile
```
1. add the following line:  
```
export PATH=$PATH:/usr/local/texlive/2014/bin/x86_64-linux/
```
