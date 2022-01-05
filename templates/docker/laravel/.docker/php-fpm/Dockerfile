FROM php:fpm-alpine

# Mandatory depencencies
RUN apk add --update --no-cache \
  libzip-dev libpng-dev icu icu-dev

# Enable PHP extensions
# ADD https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions /usr/local/bin/
RUN docker-php-ext-install bcmath gd zip pdo pdo_mysql intl exif

# Handle locales
ENV MUSL_LOCALE_DEPS cmake make musl-dev gcc gettext-dev libintl
ENV MUSL_LOCPATH /usr/share/i18n/locales/musl

RUN apk add --no-cache \
    $MUSL_LOCALE_DEPS \
    && wget https://gitlab.com/rilian-la-te/musl-locales/-/archive/master/musl-locales-master.zip \
    && unzip musl-locales-master.zip \
      && cd musl-locales-master \
      && cmake -DLOCALE_PROFILE=OFF -D CMAKE_INSTALL_PREFIX:PATH=/usr . && make && make install \
      && cd .. && rm -r musl-locales-master

# Use local timezone
RUN apk upgrade --update \
  && apk add -U tzdata \
  && cp /usr/share/zoneinfo/Europe/Paris /etc/localtime \
  && apk del tzdata

# Mysql client availability (artisan db)
RUN apk add mysql-client

# Install composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Enable schedule task runner with cron daemon
RUN apk add --no-cache su-exec
RUN echo "* * * * * su-exec www-data php /var/www/app/artisan schedule:run > /proc/1/fd/1 2>/proc/1/fd/2" > /tmp/crontab && \
    crontab /tmp/crontab && \
    rm /tmp/crontab

# Enable tinker local permissions
ENV XDG_CONFIG_HOME=/tmp

# RUN apk add --update \
#   sqlite \
#   && rm -rf /var/cache/apk/*

RUN rm -rf /var/cache/apk/*

# Set working directory
WORKDIR /var/www/app
