#! /bin/sh
chmod -R 777 /var/www/app/data
chown -R nginx:nginx /var/www/app/data
chown -R nginx:nginx /var/www/app/plugins
#nginx
#php-fpm7 -F
exec /bin/s6-svscan /etc/services.d
