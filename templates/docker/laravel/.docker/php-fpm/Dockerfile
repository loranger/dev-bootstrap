FROM php:fpm-alpine

RUN apk add --update --no-cache \
  libzip-dev libpng-dev \
  && rm -rf /var/cache/apk/*

# ADD https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions /usr/local/bin/
RUN docker-php-ext-install bcmath gd zip pdo pdo_mysql

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY .docker/php-fpm/run-scheduler.sh /usr/bin/run-scheduler

# RUN apk add --update \
#   sqlite \
#   && rm -rf /var/cache/apk/*
