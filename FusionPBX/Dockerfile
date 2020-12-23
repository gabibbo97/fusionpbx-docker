# Seen at https://github.com/fusionpbx/fusionpbx-install.sh/commit/3a63d467fd7cf28f0c21d94a4872e5c5ebd674c7
FROM debian:10.7
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
  apt-get update && apt-get install -y git
## Core
ARG FUSIONPBX_VERSION=37350b4fa7c7b08b8e70fc1923f537ccf50a0bb7
WORKDIR /var/www/fusionpbx
RUN mkdir -p /var/cache/fusionpbx /var/www/fusionpbx \
  && git clone https://github.com/fusionpbx/fusionpbx.git /var/www/fusionpbx \
  && git checkout ${FUSIONPBX_VERSION} \
  && mkdir -p /etc/fusionpbx
## Apps
RUN mkdir -p /var/www/fusionpbx/app/command \
  && git clone https://github.com/fusionpbx/fusionpbx-app-command.git /var/www/fusionpbx/app/command
RUN mkdir -p /var/www/fusionpbx/app/edit \
  && git clone https://github.com/fusionpbx/fusionpbx-app-edit.git /var/www/fusionpbx/app/edit
# Permissions
RUN \
  chown -R freeswitch:freeswitch /var/cache/fusionpbx && \
  chown -R freeswitch:freeswitch /var/www/fusionpbx && \
  chown -R freeswitch:freeswitch /etc/fusionpbx
# Configure FreeSwitch <-> FusionPBX integration
RUN \
  rm -rf /etc/freeswitch && \
  ln -sf /var/www/fusionpbx/resources/templates/conf /etc/freeswitch && \
  rm -rf /usr/share/freeswitch/scripts && \
  ln -sf /var/www/fusionpbx/app/scripts/resources/scripts /usr/share/freeswitch/scripts && \
  rm -rf /usr/share/freeswitch/sounds/music/8000/* \
  rm -rf /usr/share/freeswitch/sounds/music/16000/* \
  rm -rf /usr/share/freeswitch/sounds/music/32000/* \
  rm -rf /usr/share/freeswitch/sounds/music/48000/*
# Clean
RUN \
  apt-get clean && apt-get autoclean
# Configs
COPY php.ini /etc/php/7.3/conf.d/fusionpbx.ini
COPY fpm-pool.conf /etc/php/7.3/fpm/pool.d/freeswitch.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY supervisord.conf /etc/supervisor/supervisord.conf
# Entrypoint
WORKDIR /var/www/fusionpbx
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh && ln -sf /usr/local/bin/entrypoint.sh /entrypoint
ENTRYPOINT [ "/entrypoint" ]
