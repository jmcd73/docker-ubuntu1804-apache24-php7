#!/bin/bash

# run the following build command
# before running this file
# docker build -t tgn/tgn-wms:v14 .

WEB_DIR=test
CUPS_PORT=8631
APACHE_PORT=8091
DOCKER_TAG=tgn/tgn-wms:v20
VOLUME=/home/jm/sites/afewms/
CONTAINER_NAME=${WEB_DIR}

/bin/echo -n "Removing ${CONTAINER_NAME} container! Do you want to continue? [N/y]"
read s

case ${s} in
Y | y)
    docker stop ${CONTAINER_NAME}
    docker rm ${CONTAINER_NAME}
    ;;
*)
    echo Skipping Container Delete
    ;;
esac

/bin/echo -n "Do you want to add
CONTAINER_NAME: ${CONTAINER_NAME}
CUPS_PORT: ${CUPS_PORT},
APACHE_PORT: ${APACHE_PORT},
VOLUME: ${VOLUME},
from the DOCKER_TAG: ${DOCKER_TAG} image?
Do you want to continue? [N/y]"
read s

#         -v ~/.composer/docker-cache/:/root/.composer:cached \

case ${s} in
y | Y)
    docker run  --name $CONTAINER_NAME \
        -v ${VOLUME}:/var/www/${WEB_DIR}:Z -d \
        -p ${APACHE_PORT}:80 \
        -p ${CUPS_PORT}:631 \
        -e WEB_DIR=${WEB_DIR} \
        -e CUPS_PORT=${CUPS_PORT} \
        -e APACHE_PORT=${APACHE_PORT} $DOCKER_TAG
    ;;
*)
    echo Skipping adding container
    exit 1
    ;;
esac

# ./cache
#./cache/persistent
#./cache/models
#./logs

# mkdir -p tmp/{cache/{persistent,models},logs}
