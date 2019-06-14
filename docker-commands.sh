# docker build -t toggen/100pbc:ubuntu16-apache2-php7 .

/bin/echo -n "Removing all containers! Do you want to continue? [N/y]"
read s

if [ "$s." != "y." ] ; then
	echo Skipping Delete Containers

else
	echo Deleting all containers
	docker rm $(docker ps -qa)

fi

# toggen/100pbc       ubuntu16-apache2-php7
docker run  --name 100pbc2 \
-v ~/sites/100pbc:/var/www  -d \
-p 632:631 -p 8081:80 toggen/100pbc:20190614

# publish cups to docker host on 632 
# publish apache to docker host on 8081
