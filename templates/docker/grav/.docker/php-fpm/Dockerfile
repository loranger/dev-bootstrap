FROM php:fpm-alpine

RUN apk add --no-cache libzip-dev libpng-dev freetype-dev libjpeg-turbo-dev
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd zip

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Enable writable composer cache
RUN mkdir -p /.cache/composer && chmod 777 /.cache/composer
