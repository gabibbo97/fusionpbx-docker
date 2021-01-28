#!/bin/sh
#
# Write configuration file
#
# cat > /etc/fusionpbx.php <<EOF
# <?php
#   $db_type = 'pgsql';

#   $db_host = '${DB_HOST}';
#   $db_port = '5432';

#   $db_username = '${DB_USER}';
#   $db_password = '${DB_PASS}';

#   ini_set('display_errors', '1');
#   error_reporting(E_ALL);
# EOF
#
# Configure mod_xml_cdr
#
sed -i /etc/freeswitch/autoload_configs/xml_cdr.conf.xml \
  -e "s/{v_http_protocol}/http/" \
  -e "s/{domain_name}/localhost/" \
  -e "s/{v_project_path}//" \
  -e "s/{v_user}/$(tr -dc 'a-zA-Z0-9' /dev/urandom | head -c 20)/" \
  -e "s/{v_pass}/$(tr -dc 'a-zA-Z0-9' /dev/urandom | head -c 20)/"
#
# Perform preparation steps
#
(
  cd /var/www/fusionpbx

  echo 'Upgrading schemas'
  php core/upgrade/upgrade_schema.php

  echo 'Upgrading domains'
  php core/upgrade/upgrade_domains.php
)
#
# Run program
#
exec supervisord -c /etc/supervisor/supervisord.conf
