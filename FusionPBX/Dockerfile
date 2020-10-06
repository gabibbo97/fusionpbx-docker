FROM debian:10
# FreeSwitch
ARG FREESWITCH_VERSION=1.10.5~release~17~25569c1631~buster-1~buster+1
RUN \
  apt-get update \
  && apt-get install -y gnupg2 wget lsb-release \
  && wget -O - https://files.freeswitch.org/repo/deb/debian-release/fsstretch-archive-keyring.asc | apt-key add - \
  && echo "deb http://files.freeswitch.org/repo/deb/debian-release/ `lsb_release -sc` main" > /etc/apt/sources.list.d/freeswitch.list \
  && echo "deb-src http://files.freeswitch.org/repo/deb/debian-release/ `lsb_release -sc` main" >> /etc/apt/sources.list.d/freeswitch.list \
  && apt-get update && apt-get install -y freeswitch-meta-all=${FREESWITCH_VERSION}
# NGINX
RUN \
  apt-get update && apt-get install -y nginx
# PHP
RUN \
  apt-get update && apt-get install -y \
    php7.3 \
    php7.3-cli \
    php7.3-fpm \
    php7.3-pgsql \
    php7.3-sqlite3 \
    php7.3-odbc \
    php7.3-curl \
    php7.3-imap \
    php7.3-xml \
    php7.3-gd
RUN rm -f /etc/php/7.3/fpm/pool.d/*
RUN mkdir -p /var/run/php
# Supervisor
RUN \
  apt-get update && apt-get install -y supervisor
# FusionPBX
RUN \
  apt-get update && apt-get install -y git \
  && mkdir -p /var/www/fusionpbx \
  && git clone --depth=1 https://github.com/fusionpbx/fusionpbx.git /var/www/fusionpbx \
  && mkdir -p /etc/fusionpbx \
  && chown -R freeswitch:freeswitch /var/www/fusionpbx \
  && chown -R freeswitch:freeswitch /etc/fusionpbx
# Clean
RUN \
  apt-get clean && apt-get autoclean
# Configs
COPY fpm-pool.conf /etc/php/7.3/fpm/pool.d/freeswitch.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY supervisord.conf /etc/supervisor/supervisord.conf
# Entrypoint
ENTRYPOINT [ "supervisord", "-c", "/etc/supervisor/supervisord.conf" ]
