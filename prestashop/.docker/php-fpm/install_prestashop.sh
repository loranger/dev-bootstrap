#!/usr/bin/env sh

if [ ! -f "/var/www/app/prestashop.zip" ]; then
    latest=$(curl -s https://api.github.com/repos/prestashop/prestashop/releases/latest | grep "browser_download_url.*zip" | cut -d '"' -f 4)
    curl -L -o /var/www/app/latest.zip "$latest"
    unzip -o /var/www/app/latest.zip -d /var/www/app/
    rm -f /var/www/app/latest.zip
fi

unzip -o /var/www/app/prestashop.zip -d /var/www/app/

clear

read -p 'Firstname: ' firstname
read -p 'Lastname: ' lastname
read -sp 'Password: ' password
echo
read -p 'Email: ' email
read -p 'Language [fr]:' language
language=${language:-fr}
read -p 'Country [FR]:' country
country=${country:-FR}

PS_ALL_LANGUAGES=0
PS_ENABLE_SSL=0

php /var/www/app/install/index_cli.php \
        --domain="$APP_URL" --db_server=$DB_HOST:$DB_PORT --db_name="$DB_DATABASE" --db_user=$DB_USERNAME \
        --db_password=$DB_PASSWORD --prefix="$DB_PREFIX" --firstname="$firstname" --lastname="$lastname" \
        --password=$password --email="$email" --language=$language --country=$country \
        --all_languages=$PS_ALL_LANGUAGES --newsletter=0 --send_email=0 --ssl=$PS_ENABLE_SSL

mv /var/www/app/admin /var/www/app/$APP_ADMIN
rm -rf /var/www/app/install
rm /var/www/app/prestashop.zip
