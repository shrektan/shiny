#!/bin/sh

# RUN ShinyServer

# Make sure the directory for individual app logs exists
mkdir -p /var/log/shiny-server
sudo chown -R shiny /srv/shiny-server/* # should have the writing access by default
chown shiny.shiny /var/log/shiny-server

source shiny-server >> /var/log/shiny-server.log 2>&1

# RUN RStudioServer

sudo mkdir -p /var/log/supervisor \
	  && chgrp staff /var/log/supervisor \
	  && chmod g+w /var/log/supervisor \
	  && chgrp staff /etc/supervisor/conf.d/supervisord.conf

source /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
