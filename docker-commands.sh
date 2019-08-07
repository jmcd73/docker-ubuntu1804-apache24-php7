# docker build -t toggen/tgn-img:ubuntu16-apache2-php7 .

/bin/echo -n "Removing all containers! Do you want to continue? [N/y]"
read s

if [ "$s." != "y." ] ; then
	echo Skipping Delete Containers

else
	echo Deleting all containers
	docker rm $(docker ps -qa)

fi

CUPS_PORT=633
APACHE_PORT=8082
DOCKER_TAG=toggen/php73:latest
VOLUME=~/sites/100pbc/wms
CONTAINER_NAME=tgn

docker run  --name $CONTAINER_NAME \
-v ${VOLUME}:/var/www  -d \
-p ${CUPS_PORT}:631 -p ${APACHE_PORT}:80 $DOCKER_TAG
# toggen/tgn-img       20190614.2
# publish cups to docker host on 632
# publish apache to docker host on 8081

