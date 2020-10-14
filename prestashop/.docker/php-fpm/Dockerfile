FROM php:fpm-alpine

RUN apk add --update --no-cache \
    freetype-dev \
    libjpeg-turbo-dev \
    libjpeg-turbo \
    libzip-dev \
    libpng-dev \
    jpeg-dev \
    icu-dev \
    oniguruma-dev \
    libxml2-dev \
    && rm -rf /var/cache/apk/*

# ADD https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions /usr/local/bin/
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install bcmath gd iconv intl mbstring pdo pdo_mysql soap zip

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# RUN apk add --update \
#   sqlite \
#   && rm -rf /var/cache/apk/*
