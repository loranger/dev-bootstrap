FROM php:7-alpine

RUN apk add --no-cache libzip-dev libpng-dev
RUN docker-php-ext-install gd zip

WORKDIR /grav
EXPOSE 80
