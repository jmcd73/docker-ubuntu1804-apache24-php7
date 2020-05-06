# docker-ubuntu1804-apache2-php7+

A docker image based on Ubuntu 20.04 LTS with Apache2 + PHP 7.4 + Cups 2.2.x.

Forked from francarmona/docker-ubuntu16-apache2-php7

I use this image to develop a CakePHP 4.x application on my Macbook using Docker Desktop for Mac

The Docker Image contains support for the following

- CUPS to receive and send print jobs
- TCPDF for printing PDF's (gd required to embed images)
- glabels-batch-qt for printing labels and barcodes
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

## Out of the box

- Ubuntu 20.04 LTS
- Apache2 with mod perl and php
- PHP7.4
- CUPS with a cups-pdf print queue
- Composer
- Supervisord (to manage running both Cups and Apache in the container)

## Packages included
See Dockerfile for package list

## Exposed ports

- 631
- 80

## Exposed volumes

- webroot: `/var/www`