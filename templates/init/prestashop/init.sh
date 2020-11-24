#!/usr/bin/env sh

echo "Creating “$1” Prestashop project"

echo "Downloading latest PrestaShop, this may take a while ...";

latest=$(curl -s https://api.github.com/repos/prestashop/prestashop/releases/latest | grep "browser_download_url.*zip" | cut -d '"' -f 4)

curl -s -L -o `slugify $1`.zip "$latest"
unzip -qq -o `slugify $1`.zip -d `slugify $1`
rm -f `slugify $1`.zip

cd `slugify $1`

echo "Expanding PrestaShop, this may take a while ...";

unzip -qq -o prestashop.zip -d .
rm -f prestashop.zip
