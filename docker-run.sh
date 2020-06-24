#!/bin/bash

# run the following build command
# before running this file
# docker build -t tgn/tgn-wms:v14 .

PASSWORD=$(zenity --password --title="Docker Root Password" 2>/dev/null)

if [ -f ./.docker-env ]; then
    source ./.docker-env
fi

if [ -z "$WEB_DIR" ]; then
    echo Plese create a .docker-env file and specify
    echo WEB_DIR=app
    echo CUPS_PORT=8666
    echo APACHE_PORT=8999
    echo DOCKER_TAG=tgn/tgn-wms:v22
    echo VOLUME=/var/www/afewms/\${WEB_DIR}
    echo CONTAINER_NAME=\${WEB_DIR}
    exit
fi

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
    docker run --name $CONTAINER_NAME \
        -v ${VOLUME}:/var/www/${WEB_DIR}:Z -d \
        -p ${APACHE_PORT}:80 \
        -p ${CUPS_PORT}:631 \
        -e WEB_DIR=${WEB_DIR} \
        -e CUPS_PORT=${CUPS_PORT} \
        -e APACHE_PORT=${APACHE_PORT} $DOCKER_TAG

    if [ -n "${PASSWORD}" ]; then
        echo Changing root password
        echo "root:${PASSWORD}" | docker exec -i ${CONTAINER_NAME} chpasswd
    fi

    ;;
*)
    echo Skipping adding container
    exit 1
    ;;
esac
