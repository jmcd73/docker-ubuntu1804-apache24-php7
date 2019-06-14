# docker-ubuntu1804-apache2-php72
A docker image based on Ubuntu 18.04 LTS with Apache2 + PHP 7.2 + Cups 2.2.x

Clone this repo and run docker build

```
docker build -t toggen/tgn-img:20190614.2 .
```

## Run

After building the image, run the container.
```

docker run  --name tgn-img \
-v ~/sites/tgn-img:/var/www  -d \
-p [host-port I use 632]:631 -p [host-port I use 8080]:80 toggen/tgn-img:20190614.2

```
Browse to [http://localhost:[host-port]](http://localhost:[host-port]) to view your app.

## Packages included

 * php7.2
 * php7.2-cli
 * apache2
 * php7.2-gd
 * php7.2-json
 * php7.2-mbstring
 * php7.2-xml
 * php7.2-xsl
 * php7.2-zip
 * php7.2-soap
 * php7.2-pear
 * php7.2-mcrypt
 * php7.2-curl
 * php-mysql
 * curl
 * libapacha2-mod-php
 * apt-transport-https
 * nano
 * vim (because nano bites)
 * php7.2-mysql
 * mysql-client ( to test connectivity )
 * lynx-cur
 * composer
 * supervisor
 * cups

## Exposed ports

631
80

## Exposed volumes

 - webroot: `/var/www`

## Out of the box

 * Ubuntu 18.04 LTS
 * Apache2
 * PHP7.2
 * CUPS
 * Composer
 * Supervisord (to manage running cups and apache in the container)
