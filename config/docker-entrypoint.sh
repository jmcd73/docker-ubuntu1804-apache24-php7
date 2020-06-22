#!/bin/bash
set -e

CUPS_PDF=/etc/cups/cups-pdf.conf
APACHE_CONF=/etc/apache2/sites-enabled/000-default.conf


if [ "$1" = '/usr/bin/supervisord' ]; then

    if [ ! -f "${CUPS_PDF}.init" ]; then
        sed -i.init -e "s+^Out.*+Out /var/www/${WEB_DIR}/PDF+g" ${CUPS_PDF}
    fi

    if [ ! -f "${APACHE_CONF}.init" ]; then
       sed -i.init -e "s+Alias.*+Alias /${WEB_DIR} /var/www/${WEB_DIR}/webroot+g" ${APACHE_CONF}
    fi

fi

exec "$@"
