# docker-ubuntu1804-apache2-php72
A docker image based on Ubuntu 18.04 LTS with Apache2 + PHP 7.2 + Cups 2.2.x

## Pull the image

Pull the latest stable version from the [Docker Hub Registry](https://hub.docker.com/r/francarmona/docker-ubuntu16-apache2-php7/)
```
docker pull francarmona/docker-ubuntu16-apache2-php7:latest
```

If you prefer building the image from source, clone the repository and run docker build

```
git clone https://github.com/franCarmona/docker-ubuntu16-apache2-php7.git
docker build -t francarmona/docker-ubuntu16-apache2-php7 .
```

## Run

After building the image, run the container.
```
docker run --name apache2-php7 -v ~/path/to/code:/var/www -d -p [host-port]:80 francarmona/docker-ubuntu16-apache2-php7
```
Browse to [http://localhost:[host-port]](http://localhost:[host-port]) to view your app.

## Use as a base image

Some cases will be necessary to create a new image using this one as the base, for example to overwrite configuration files.

Create a Dockerfile with following content and then build the image.

```Dockerfile
FROM francarmona/docker-ubuntu16-apache2-php7

LABEL maintainer="Your Name <your@email>"
LABEL description="A docker image based on Ubuntu 16.04 with Apache2 + PHP 7.0"

# Apache site conf
ADD config/apache/apache-virtual-hosts.conf /etc/apache2/sites-enabled/000-default.conf
ADD config/apache/apache2.conf /etc/apache2/apache2.conf
```

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
 * Supervisord
