#!/usr/bin/env sh

mysql -h $DB_SERVER -P $DB_PORT -u $DB_USER -p$DB_PASSWD $DB_NAME <<SET_QUERY
USE $DB_NAME
UPDATE ps_shop_url SET domain = '$PS_DOMAIN', domain_ssl = '$PS_DOMAIN' WHERE id_shop = 1;
UPDATE ps_configuration SET value = '$PS_DOMAIN' WHERE name = 'PS_SHOP_DOMAIN' OR name = 'PS_SHOP_DOMAIN_SSL';
UPDATE ps_configuration SET value = '$PS_ENABLE_SSL' WHERE name = 'PS_SSL_ENABLED' OR name = 'PS_SSL_ENABLED_EVERYWHERE';
SET_QUERY

if [[ $PS_ENABLE_SSL = 1 ]];
then
    scheme="https"
else
    scheme="http"
fi

echo "Prestashop shop_id 1 now uses ${scheme}://${PS_DOMAIN}"
