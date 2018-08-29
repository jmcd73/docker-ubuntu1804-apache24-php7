# docker build -t toggen/100pbc:ubuntu16-apache2-php7 .

docker run --name 100pbc-apache2-php7 \
-v ~/sites/100pbc:/var/www -d -p 8081:80 toggen/100pbc:ubuntu16-apache2-php7