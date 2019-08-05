# docker build -t toggen/tgn-img:ubuntu16-apache2-php7 .

/bin/echo -n "Removing all containers! Do you want to continue? [N/y]"
read s

if [ "$s." != "y." ] ; then
	echo Skipping Delete Containers

else
	echo Deleting all containers
	docker rm $(docker ps -qa)

fi

docker run  --name tgn \
-v ~/sites/wms:/var/www  -d \
-p 633:631 -p 8082:80 toggen/jmcd:20190614.3
# toggen/tgn-img       20190614.2
# publish cups to docker host on 632
# publish apache to docker host on 8081

