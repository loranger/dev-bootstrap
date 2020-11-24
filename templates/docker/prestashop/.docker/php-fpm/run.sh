#!/usr/bin/env sh

if [ "${DISABLE_MAKE}" != "1" ]; then
  echo "* Running composer ...";
  su - www-data -s /bin/bash -c '/usr/local/bin/composer install --no-interaction'

  echo "* Build assets ...";
  su - www-data -s /bin/bash -c '/usr/bin/make assets'
fi

if [ "$DB_SERVER" = "<to be defined>" -a $PS_INSTALL_AUTO = 1 ]; then
    echo >&2 'error: You requested automatic PrestaShop installation but MySQL server address is not provided '
    echo >&2 '  You need to specify DB_SERVER in order to proceed'
    exit 1
elif [ "$DB_SERVER" != "<to be defined>" -a $PS_INSTALL_AUTO = 1 ]; then
    RET=1
    while [ $RET -ne 0 ]; do
        echo "* Checking if $DB_SERVER is available..."
        mysql -h $DB_SERVER -P $DB_PORT -u $DB_USER -p$DB_PASSWD -e "status" > /dev/null 2>&1
        RET=$?

        if [ $RET -ne 0 ]; then
            echo "* Waiting for confirmation of MySQL service startup";
            sleep 5
        fi
    done
        echo "* DB server $DB_SERVER is available, let's continue !"
fi

# From now, stop at error
set -e

if [ ! -f ./config/settings.inc.php ]; then
    if [ $PS_INSTALL_AUTO = 1 ]; then

        if [ ! -d ./config ]; then
            echo "* Downloading PrestaShop, this may take a while ...";

            latest=$(curl -s https://api.github.com/repos/prestashop/prestashop/releases/latest | grep "browser_download_url.*zip" | cut -d '"' -f 4)
            curl -s -L -o /var/www/app/latest.zip "$latest"
            su - www-data -s /bin/bash -c '/usr/bin/unzip -qq -o /var/www/app/latest.zip -d /var/www/app/'
            rm -f /var/www/app/latest.zip

            echo "* Expanding PrestaShop, this may take a while ...";

            su - www-data -s /bin/bash -c '/usr/bin/unzip -qq -o /var/www/app/prestashop.zip -d /var/www/app/'
        fi

        echo "* Installing PrestaShop, this may take a while ...";

        if [ $PS_ERASE_DB = 1 ]; then
            echo "* Drop & recreate mysql database...";
            if [ $DB_PASSWD = "" ]; then
                echo "* Dropping existing database $DB_NAME..."
                mysql -h $DB_SERVER -P $DB_PORT -u $DB_USER -e "drop database if exists $DB_NAME;"
                echo "* Creating database $DB_NAME..."
                mysqladmin -h $DB_SERVER -P $DB_PORT -u $DB_USER create $DB_NAME --force;
            else
                echo "* Dropping existing database $DB_NAME..."
                mysql -h $DB_SERVER -P $DB_PORT -u $DB_USER -p$DB_PASSWD -e "drop database if exists $DB_NAME;"
                echo "* Creating database $DB_NAME..."
                mysqladmin -h $DB_SERVER -P $DB_PORT -u $DB_USER -p$DB_PASSWD create $DB_NAME --force;
            fi
        fi

        if [ "$PS_DOMAIN" = "<to be defined>" ]; then
            export PS_DOMAIN=$(hostname -i)
        fi

        echo "* Launching the installer script..."
        su - www-data -s /bin/bash -c "/usr/local/bin/php /var/www/app/$PS_FOLDER_INSTALL/index_cli.php \
        --domain=\"$PS_DOMAIN\" --db_server=$DB_SERVER:$DB_PORT --db_name=\"$DB_NAME\" --db_user=$DB_USER \
        --db_password=$DB_PASSWD --prefix=\"$DB_PREFIX\" --firstname=\"$ADMIN_FIRSTNAME\" --lastname=\"$ADMIN_LASTNAME\" \
        --password=$ADMIN_PASSWD --email=\"$ADMIN_MAIL\" --language=$PS_LANGUAGE --country=$PS_COUNTRY \
        --all_languages=$PS_ALL_LANGUAGES --newsletter=0 --send_email=0 --ssl=$PS_ENABLE_SSL"

        mv /var/www/app/admin /var/www/app/$PS_FOLDER_ADMIN
        rm -rf /var/www/app/PS_FOLDER_INSTALL
        rm /var/www/app/prestashop.zip

        if [ $? -ne 0 ]; then
            echo 'warning: PrestaShop installation failed.'
        fi
    fi
else
    echo "* Pretashop Core already installed...";
fi

if [ $PS_DEMO_MODE -ne 0 ]; then
    echo "* Enabling DEMO mode ...";
    sed -ie "s/define('_PS_MODE_DEMO_', false);/define('_PS_MODE_DEMO_',\ true);/g" /var/www/app/config/defines.inc.php
fi

echo "* Almost ! Starting web server now";

exec php-fpm -F
