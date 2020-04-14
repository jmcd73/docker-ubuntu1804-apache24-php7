# docker-ubuntu1804-apache2-php7+

A docker image based on Ubuntu 18.04 LTS with Apache2 + PHP 7.4 + Cups 2.2.x.

Forked from francarmona/docker-ubuntu16-apache2-php7

I use this image to develop a CakePHP 2.x application on my Macbook using Docker Desktop for Mac

The CakePHP application uses the following so the Docker Image contains support for the following

- CUPS to receive and send print jobs
- TCPDF for printing PDF's (gd required to embed images)
- glabels-3-batch for printing labels and barcodes
- MySQL or Maria DB

Clone this repo and run docker build

```
docker build -t <repository>:<tag> .

# examples
docker build -t toggen/tgn-img:20190614.2 .
docker build -t tgn/php73:v1 .
```

## Run

After building the image, run the container. You can use the `docker-commands.sh` script to do this also

```
docker run  --name tgn-img \
-v ~/sites/tgn-img:/var/www  -d \
-p [cups_port I use 632]:631 \
-p [apache_port I use 8080]:80 toggen/tgn-img:20190614.2
```

Browse to [http://localhost:[apache_port]](http://localhost:[apache_port]) to view your app.

## Packages included

- apache2
- supervisor
- php7.4
- php7.4-cli
- php7.4-gd
- php7.4-json
- php7.4-mbstring
- php7.4-opcache
- php7.4-xml
- php7.4-mysql
- php7.4-curl
- php7.4-intl
- php7.4-sqlite3
- libapache2-mod-php7.4
- curl
- apt-transport-https
- vim
- cpanminus
- cups
- cups-bsd
- cups-client
- printer-driver-cups-pdf
- libfcgi-perl
- mysql-client
- nmap
- iproute2
- hplip
- locales
- git
- unzip
- php-xdebug
- xz-utils
- cmake
- glabels (compiled with zint and barcode support)

## Exposed ports

- 631
- 80

## Exposed volumes

- webroot: `/var/www`

## Out of the box

- Ubuntu 18.04 LTS
- Apache2 with mod perl and php
- PHP7.4
- CUPS with a cups-pdf print queue
- Composer
- Supervisord (to manage running both Cups and Apache in the container)
