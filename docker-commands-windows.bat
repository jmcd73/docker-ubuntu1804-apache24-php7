set WWW_PORT=8051
set CUPS_PORT=651
set TAG=tgn/tgn-wms:v2
set VOL=C:/Users/jmcd7/sites/tgn-wms-cakephp4

docker run --name tgnwms2 ^
-v %VOL%:/var/www:delegated -d ^
-p %WWW_PORT%:80 -p %CUPS_PORT%:631 ^
-e CUPS_PORT=%CUPS_PORT% ^
-e APACHE_PORT=%WWW_PORT% %TAG%