FROM ubuntu:20.04
LABEL maintainer="James McDonald <james@toggen.com.au>"
LABEL description="Ubuntu 20.04+, Apache 2.4+, PHP 7.4+"

# docker build -t toggen/tgn-img:20190614.2 .

# Environments vars
ENV TERM=xterm

# set a default root password
RUN echo "root:HeartMindSoul" | chpasswd

RUN apt-get clean all
RUN apt-get update
RUN apt-get update && apt-get -y dist-upgrade
RUN apt-get -y install software-properties-common
RUN sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list
RUN apt-get clean all
RUN apt-get update

# Packages installation
RUN DEBIAN_FRONTEND=noninteractive apt-get -y --fix-missing install apache2 \
    supervisor \
    php \
    php-cli \
    php-gd \
    php-json \
    php-mbstring \
    php-opcache \
    php-xml \
    php-mysql \
    php-curl \
    php-intl \
    php-sqlite3 \
    libapache2-mod-php \
    curl \
    apt-transport-https \
    vim \
    cups \
    cups-bsd \
    cups-client \
    printer-driver-cups-pdf \
    mysql-client \
    nmap \
    iproute2 \
    hplip \
    locales \
    git \
    unzip \
    php-xdebug \
    xz-utils \
    libgl1 \
    libqt5x11extras5 \
    npm \
    nodejs \
    xvfb
# installs xvfb-run for allowing glabels-batch-qt to run

RUN apt-get clean all
RUN a2enmod rewrite
RUN a2enmod headers

# glabels needs to be compiled from source
# because the default install doesn't have zint
# needed for GS1-128 barcodes

RUN wget https://github.com/jimevins/glabels-qt/releases/download/glabels-3.99-master561/glabels-3.99-master561-x86_64.AppImage && \
    chmod +x glabels-3.99-master561-x86_64.AppImage && \
    ./glabels-3.99-master561-x86_64.AppImage --appimage-extract && \
    mv squashfs-root /usr/local/glabels-qt && \
    rm -f glabels-3.99-master561-x86_64.AppImage

RUN find /usr/local/glabels-qt -type d -exec chmod 0775 {} \;
RUN find /usr/local/glabels-qt -type f -exec chmod 0775 {} \;

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
ENV LANG "en_AU.UTF-8"
ENV LANGUAGE "en_AU:en"
ENV LC_ALL "en_AU.UTF-8"
# ENV PATH "$PATH:/usr/local/glabels-qt/usr/bin"
# ENV LD_LIBRARY_PATH "/usr/local/glabels-qt/usr/lib:$LD_LIBRARY_PATH"

# Update php.ini
COPY config/php/php.conf /etc/php/7.4/apache2/php.ini

RUN sed -ibak -e s+/usr/lib/cgi-bin+/var/www/cgi-bin+g /etc/apache2/conf-enabled/serve-cgi-bin.conf

RUN service apache2 restart

RUN chown -R www-data:www-data /var/www

#RUN sed -i.bak '1i ServerAlias *' /etc/cups/cupsd.conf

COPY config/cups/cupsd.conf /etc/cups/
COPY config/cups/printers.conf /etc/cups/
COPY config/cups/PDF.ppd /etc/cups/ppd/

RUN sed -i.bak -e 's+Out.*+Out /var/www/PDF+g' /etc/cups/cups-pdf.conf


#RUN /usr/sbin/cupsd -f && cupsctl --remote-admin --remote-any --share-printers

WORKDIR /var/www/

# Volume
VOLUME /var/www

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
