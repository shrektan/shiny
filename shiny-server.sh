#!/bin/sh

# ShinyServer: Make sure the directory for individual app logs exists
mkdir -p /var/log/shiny-server
sudo chown -R shiny /srv/shiny-server/* # should have the writing access by default
chown shiny.shiny /var/log/shiny-server

# RUN ShinyServer
exec shiny-server >> /var/log/shiny-server.log 2>&1

# Currently it's not able to RUN the two at the same time, 
# because no source or fork command when executing this script, and 
# I totally have no idea.
