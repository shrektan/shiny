#!/bin/sh

# RstudioServer: prepare to run
sudo mkdir -p /var/log/supervisor \
	  && chgrp staff /var/log/supervisor \
	  && chmod g+w /var/log/supervisor \
	  && chgrp staff /etc/supervisor/conf.d/supervisord.conf

# RUN RStudioServer
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
