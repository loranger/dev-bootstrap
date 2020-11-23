FROM php:cli-alpine

# RUN apk add --update --no-cache \
#   sqlite \
#   && rm -rf /var/cache/apk/*

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create system user to run Composer and Artisan Commands
# RUN useradd -G www-data,root -u $uid -d /home/$user $user
# RUN mkdir -p /home/$user/.composer && \
#     chown -R $user:$user /home/$user

# ADD https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions /usr/local/bin/
# RUN docker-php-ext-install pdo pdo_sqlite
