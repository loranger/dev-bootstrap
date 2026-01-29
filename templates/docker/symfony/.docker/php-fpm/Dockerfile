FROM php:fpm-alpine

# Mandatory depencencies
RUN apk add --update --no-cache \
  libzip-dev libpng-dev icu icu-dev

# Enable PHP extensions
# ADD https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions /usr/local/bin/
RUN docker-php-ext-install bcmath gd zip pdo pdo_mysql intl exif

ADD https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions xdebug

# Handle locales
RUN apk add musl-locales musl-locales-lang

# Use local timezone
RUN apk upgrade --update \
  && apk add -U tzdata \
  && cp /usr/share/zoneinfo/Europe/Paris /etc/localtime \
  && apk del tzdata

# Install composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Enable writable composer cache
RUN mkdir -p /.cache/composer && chmod 777 /.cache/composer

WORKDIR /var/www/app

RUN rm -rf /var/cache/apk/*

# Set working directory
WORKDIR /var/www/app
