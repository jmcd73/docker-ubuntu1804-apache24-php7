FROM ubuntu:18.04
LABEL maintainer="James McDonald <james@toggen.com.au>"
LABEL description="Ubuntu 18.04+, Apache 2.4+, PHP 7.3+"

# docker build -t toggen/tgn-img:20190614.2

# Environments vars
ENV TERM=xterm

# set a default root password
RUN echo "root:HeartMindSoul" | chpasswd

RUN apt-get update
RUN apt-get -y dist-upgrade
RUN apt-get -y install software-properties-common
RUN add-apt-repository ppa:ondrej/php
RUN apt-get update

# Packages installation
RUN DEBIAN_FRONTEND=noninteractive apt-get -y --fix-missing install apache2 \
    supervisor \
    php7.3 \
    php7.3-cli \
    php7.3-gd \
    php7.3-json \
    php7.3-mbstring \
    php7.3-xml \
    php7.3-xsl \
    php7.3-zip \
    php7.3-soap \
    php-pear \
    php7.3-mysql \
    libapache2-mod-php \
    libapache2-mod-perl2 \
    curl \
    php7.3-curl \
    apt-transport-https \
    nano \
    vim \
    libconfig-simple-perl \
    libclass-csv-perl \
    libcgi-pm-perl \
    libfile-which-perl \
    cpanminus \
    cups \
    cups-bsd \
    cups-client \
    printer-driver-cups-pdf \
    libfcgi-perl \
    glabels \
    libtext-csv-encoded-perl \
    glabels-data \
    mysql-client \
    nmap \
    iproute2 \
    hplip \
    locales

RUN a2enmod rewrite
RUN a2enmod cgi
RUN a2enmod perl
RUN a2enmod headers
# RUN phpenmod mcrypt

# Composer install
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# supervisord
RUN mkdir -p /var/log/supervisor

COPY config/supervisor/supervisord.conf /etc/supervisor/supervisord.conf

# Update the default apache site with the config we created.
COPY config/apache/apache-virtual-hosts.conf /etc/apache2/sites-enabled/000-default.conf
COPY config/apache/apache2.conf /etc/apache2/apache2.conf
COPY config/apache/ports.conf /etc/apache2/ports.conf
COPY config/apache/envvars /etc/apache2/envvars

# locale
RUN touch /usr/share/locale/locale.alias
RUN sed -i -e 's/# \(en_AU\.UTF-8 .*\)/\1/' /etc/locale.gen && \
    locale-gen
ENV LANG en_AU.UTF-8
ENV LANGUAGE en_AU:en
ENV LC_ALL en_AU.UTF-8

# Update php.ini
COPY config/php/php.conf /etc/php/7.0/apache2/php.ini

# COPY phpinfo script for INFO purposes
RUN echo "<?php phpinfo();" >> /var/www/index.php

RUN sed -ibak -e s+/usr/lib/cgi-bin+/var/www/cgi-bin+g /etc/apache2/conf-enabled/serve-cgi-bin.conf

RUN service apache2 restart

RUN chown -R www-data:www-data /var/www

#RUN sed -i.bak '1i ServerAlias *' /etc/cups/cupsd.conf

COPY config/cups/cupsd.conf /etc/cups/
COPY config/cups/printers.conf /etc/cups/
RUN sed -i.bak -e 's+Out.*+Out /var/www/PDF+g' /etc/cups/cups-pdf.conf

#perl
RUN cpanm Text::CSV::Unicode

#RUN /usr/sbin/cupsd -f && cupsctl --remote-admin --remote-any --share-printers

WORKDIR /var/www/

# Volume
VOLUME /var/www

# Ports: apache2
EXPOSE 80
EXPOSE 631

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
