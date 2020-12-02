FROM php:7.2-fpm-alpine
# https://devdocs.prestashop.com/1.7/basics/installation/system-requirements/#php-compatibility-chart

RUN apk add --update --no-cache \
    autoconf \
    imagemagick \
    imagemagick-dev \
    freetype-dev \
    g++ \
    icu-dev \
    jpeg-dev \
    libjpeg-turbo-dev \
    libjpeg-turbo \
    libmemcached-dev \
    libpng-dev \
    libtool \
    libzip-dev \
    make \
    mysql-client \
    oniguruma-dev \
    procps \
    pcre-dev \
    shadow \
    libxml2-dev \
    && rm -rf /var/cache/apk/*

# ADD https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions /usr/local/bin/
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install bcmath gd iconv intl mbstring mysqli pdo pdo_mysql soap zip

RUN  pecl install imagick memcached \
    && docker-php-ext-enable imagick \
    && docker-php-ext-enable memcached

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN groupmod -g 1000 www-data \
  && usermod -u 1000 -g 1000 www-data

COPY /run.sh /tmp/
RUN chmod +x /tmp/run.sh

WORKDIR /var/www/app

CMD ["/tmp/run.sh"]
