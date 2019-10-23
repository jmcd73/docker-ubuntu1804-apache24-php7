# docker build -t toggen/tgn-img:ubuntu16-apache2-php7 .

CUPS_PORT=${1:-633}
APACHE_PORT=${2:-8083}
DOCKER_TAG=${3:-tgn/php73:v3}
VOLUME=${4:-~/sites/tgn-wms/}
CONTAINER_NAME=${5:-tgn}

/bin/echo -n "Removing ${CONTAINER_NAME} container! Do you want to continue? [N/y]"
read s

case ${s} in
	Y|y)
		docker stop ${CONTAINER_NAME}
		docker rm ${CONTAINER_NAME}
		;;
	*)
		echo Skipping Container Delete
		exit 1
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

case ${s} in
	y|Y)
		docker run  --name $CONTAINER_NAME \
		-v ${VOLUME}:/var/www  -d \
		-p ${CUPS_PORT}:631 -p ${APACHE_PORT}:80 \
		-e CUPS_PORT=${CUPS_PORT} \
		-e APACHE_PORT=${APACHE_PORT} $DOCKER_TAG
		;;
	*)
		echo Skipping adding container
		exit 1
esac

