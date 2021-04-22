FROM ubuntu:20.04
LABEL maintainer="James McDonald <james@toggen.com.au>"
LABEL description="Ubuntu 20.04+, Apache 2.4+, PHP 7.4+, Glabels 3.4.1"

# This is the production docker file
# docker build -t toggen/tgn-img:20190614.2 .

# Environments vars
ENV TERM=xterm

# set a default root password
# changed is prompted when launching container
# using docker-run.sh
RUN echo "root:HeartMindSoul" | chpasswd

# need sources to install build deps
RUN sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list
RUN apt-get update && apt-get -y dist-upgrade && apt-get -y install software-properties-common && apt-get update

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
    # needed for composer install
    curl \ 
    apt-transport-https \
    vim \
    cups \
    cups-bsd \
    cups-client \
    printer-driver-cups-pdf \
    mysql-client \
    hplip \
    locales \
    git \
    unzip \
    xz-utils \
    libgl1 \
    cmake \
    php-mailparse

# installs xvfb-run for allowing glabels-batch-qt to run
RUN apt-get -y build-dep glabels

# install fonts for PDF out put
RUN echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections
RUN apt-get install -y --no-install-recommends fontconfig ttf-mscorefonts-installer
ADD config/fonts/localfonts.conf /etc/fonts/local.conf
RUN fc-cache -f -v

# remove cruft
RUN apt-get clean all
RUN a2enmod rewrite
RUN a2enmod headers

# Glabels 4 is a big leap forward but not ready for prime time
# I notice font kerning issues with smaller font sizes 
# despite it all working very well. Will wait for it to be released
# stably before using in prod

# RUN wget https://github.com/jimevins/glabels-qt/releases/download/glabels-3.99-master561/glabels-3.99-master561-x86_64.AppImage && \
#    chmod +x glabels-3.99-master561-x86_64.AppImage && \
#    ./glabels-3.99-master561-x86_64.AppImage --appimage-extract && \
#    mv squashfs-root /usr/local/glabels-qt && \
#    rm -f glabels-3.99-master561-x86_64.AppImage

# RUN find /usr/local/glabels-qt -type d -exec chmod 0775 {} \;
# RUN find /usr/local/glabels-qt -type f -exec chmod 0775 {} \;

# Composer install
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# supervisord
RUN mkdir -p /var/log/supervisor

COPY config/supervisor/apache_cups.conf /etc/supervisor/conf.d/

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

# Update php.ini
COPY config/php/php.conf /etc/php/7.4/apache2/php.ini

RUN sed -ibak -e s+/usr/lib/cgi-bin+/var/www/cgi-bin+g /etc/apache2/conf-enabled/serve-cgi-bin.conf

# RUN service apache2 restart

RUN chown -R www-data:www-data /var/www

COPY config/cups/cupsd.conf /etc/cups/
COPY config/cups/cups-pdf.conf /etc/cups/
COPY config/cups/printers.conf /etc/cups/
COPY config/cups/PDF.ppd /etc/cups/ppd/
COPY config/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# this is eventually changed from /var/www/PDF to 
# /var/www/${WEB_DIR}/PDF by docker-entrypoint.sh
RUN sed -i.bak -e "s+Out.*+Out /var/www/PDF+g" /etc/cups/cups-pdf.conf

RUN mkdir /build && cd /build && \
wget https://downloads.sourceforge.net/project/zint/zint/2.6.3/zint-2.6.3_final.tar.gz && \
tar -xvf zint-2.6.3_final.tar.gz && \
cd zint-2.6.3.src/ && \
mkdir build && cd build && \
cmake .. && make && make install

RUN cd /build && \
wget https://ftp.gnu.org/gnu/barcode/barcode-0.98.tar.gz && \
tar xzf barcode-0.98.tar.gz && \
cd barcode-0.98/ && \
./configure && make && \
make install

RUN cd /build && \
wget http://ftp.gnome.org/pub/GNOME/sources/glabels/3.4/glabels-3.4.1.tar.xz && \
tar xvf glabels-3.4.1.tar.xz && \
cd glabels-3.4.1/ && \
./configure && \
make && make install && ldconfig

RUN rm -rf /build

WORKDIR /var/www/

# Volume
VOLUME /var/www

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# this starts and manages apache and cups
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]