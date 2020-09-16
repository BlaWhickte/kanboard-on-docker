FROM alpine:3.11
ADD https://dl.bintray.com/php-alpine/key/php-alpine.rsa.pub /etc/apk/keys/php-alpine.rsa.pub
RUN apk --update add ca-certificates && \
 echo "https://dl.bintray.com/php-alpine/v3.11/php-7.3" >> /etc/apk/repositories
RUN apk add pcre nginx php php-bz2 php-cli php-common php-curl php-fpm php-gd php-json php-mbstring php-opcache php-sqlite3 php-xml php-xmlrpc php-xsl php-zip php-pdo_sqlite php-openssl php-ctype php-session php-simplexml s6
RUN mkdir -p /run/nginx /var/www/app && touch /run/nginx/nginx.pid
RUN rm -r /etc/nginx/conf.d/default.conf
ADD src/nginx.conf /etc/nginx/nginx.conf
ADD src/crontabs/nginx /etc/crontabs/nginx
ADD src/services.d/ /etc/services.d/
RUN chmod +x -R /etc/services.d/cron/run /etc/services.d/nginx/run /etc/services.d/php/run /etc/services.d/.s6-svscan/finish
ADD src/php7/conf.d/local.ini /etc/php7/conf.d/local.ini
ADD src/php7/php-fpm.d/additional.conf /etc/php7/php-fpm.d/additional.conf
COPY src/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
RUN cp /etc/php7/php-fpm.d/www.conf /etc/php7/php-fpm.d/www.conf.back
RUN TEMP_FILE=$(mktemp) && \
               sed 's/127.0.0.1:9000/\/var\/run\/php-fpm.sock/g' /etc/php7/php-fpm.d/www.conf >> $TEMP_FILE && \
               cat $TEMP_FILE > /etc/php7/php-fpm.d/www.conf
ENTRYPOINT ["/entrypoint.sh"]
#CMD ["-c"]
