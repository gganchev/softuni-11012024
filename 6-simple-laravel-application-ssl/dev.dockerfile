FROM myimage:latest

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN apt update  \
    && apt install -y nodejs npm zip vim default-mysql-client redis-tools \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && apt clean
RUN echo "xdebug.client_host=host.docker.internal"  >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.mode=debug"  >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.start_with_request=yes"  >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.log = /tmp/xdebug.log"  >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && mkdir /etc/apache2/certificates/
COPY ./docker/dev/apache/entrypoint.sh /var/www/
COPY ./docker/certificates/output/ /etc/apache2/certificates/
RUN chmod 700 /var/www/entrypoint.sh

ENTRYPOINT ["/var/www/entrypoint.sh"]