FROM php:8.3-apache AS builder
RUN apt update && apt install -y git nodejs npm zip
COPY --chmod=600 ./docker/ssh/id_rsa /root/.ssh/
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts && git clone git@github.com:gganchev/demo-laravel-app.git .
RUN npm install \
    && npm run build \
    && composer install
RUN rm -rf /var/www/html/.git/ && rm -rf /var/www/html/node_modules/
RUN chown -R www-data:www-data /var/www/html/

FROM php:8.3-apache AS final_image
RUN a2enmod ssl rewrite deflate headers expires http2 \
    && docker-php-ext-install bcmath pdo pdo_mysql \
    && pecl install redis \
    && docker-php-ext-enable redis
COPY --from=builder /var/www/html/ /var/www/html/
COPY ./docker/apache/vhost.conf /etc/apache2/sites-enabled/000-default.conf
COPY ./docker/application/.env /var/www/html/