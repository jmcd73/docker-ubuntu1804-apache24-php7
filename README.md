# docker-ubuntu1804-apache2-php7
A docker image based on Ubuntu 18.04 LTS with Apache2 + PHP 7.3 + Cups 2.2.x.

I use this image to develop a CakePHP 2.x application on my macbook use Docker Desktop for Mac

The CakePHP application uses the following so the Docker Image contains support for the following
* CUPS to receive print jobs
* TCPDF for printing PDF's (gd required to embed images)
* glabels-3-batch for printing labels and barcodes
* MySQL or Maria DB


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

 * apache2
 * apt-transport-https
 * composer
 * cups
 * curl
 * libapache2-mod-php7.3
 * mysql-client ( to test connectivity )
 * nano
 * php-mysql
 * php7.3
 * php7.3-cli
 * php7.3-curl
 * php7.3-gd
 * php7.3-json
 * php7.3-mbstring
 * php7.3-mcrypt
 * php7.3-mysql
 * php7.3-pear
 * php7.3-soap
 * php7.3-xml
 * php7.3-xsl
 * php7.3-zip
 * supervisor
 * glabels
 * vim (because nano bites)

## Exposed ports

- 631
- 80

## Exposed volumes

 - webroot: `/var/www`

## Out of the box

 * Ubuntu 18.04 LTS
 * Apache2 with mod perl and php
 * PHP7.3
 * CUPS
 * Composer
 * Supervisord (to manage running cups and apache in the container)
