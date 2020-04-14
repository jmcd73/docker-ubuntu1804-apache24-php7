# run the following build command
# before running this file
# docker build -t tgn/tgn-wms .

CUPS_PORT=${1:-649}
APACHE_PORT=${2:-8049}
DOCKER_TAG=${3:-tgn/tgn-wms\:v7}
VOLUME=${4:-~/sites/tgn-wms-cakephp4/}
CONTAINER_NAME=${5:-tgn-wms-cakephp4}

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

case ${s} in
y | Y)
    docker run --name $CONTAINER_NAME \
        -v ${VOLUME}:/var/www -d \
        -p ${APACHE_PORT}:80 \
	-p ${CUPS_PORT}:631 \
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
