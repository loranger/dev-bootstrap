FROM php:fpm-alpine

RUN apk --update --no-cache add git

RUN docker-php-ext-install pdo_mysql

COPY --from=composer /usr/bin/composer /usr/bin/composer

# Enable writable composer cache
RUN mkdir -p /.cache/composer && chmod 777 /.cache/composer


WORKDIR /var/www

CMD composer install ; php-fpm 

EXPOSE 9000
