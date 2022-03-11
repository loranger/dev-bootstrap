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
    libmcrypt-dev \
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

RUN  pecl install imagick memcached mcrypt-1.0.1\
    && docker-php-ext-enable imagick \
    && docker-php-ext-enable memcached \
    && docker-php-ext-enable mcrypt

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Enable writable composer cache
RUN mkdir -p /.cache/composer && chmod 777 /.cache/composer


RUN groupmod -g 1000 www-data \
  && usermod -u 1000 -g 1000 www-data

COPY /set_shop.sh /usr/local/bin/set_shop
RUN chmod +x /usr/local/bin/set_shop

COPY /run.sh /usr/local/bin/run_prestashop
RUN chmod +x /usr/local/bin/run_prestashop

WORKDIR /var/www/app

CMD ["/usr/local/bin/run_prestashop"]
