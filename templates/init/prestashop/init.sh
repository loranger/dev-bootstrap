#!/usr/bin/env sh

echo "Creating “$1” Prestashop project"

presta_versions=($(curl -s "https://api.github.com/repos/prestashop/prestashop/releases?per_page=9" | grep "tag_name" | cut -d '"' -f 4))
if [[ ${#presta_versions[@]} -eq 0 ]]; then
    echo "Error while fetching Prestashop version";
    break;
fi

PS3="Which Prestashop version do you require for “$1” project: "
select version in "${presta_versions[@]}"; do
    # Manually specified version
    if [[ "$REPLY" == *"\."* || -z "${presta_versions[$REPLY]}" ]]; then
        version=$REPLY
    fi

    release=$(curl -s https://api.github.com/repos/prestashop/prestashop/releases/tags/$version);
    if [[ "$release" == *"browser_download_url"* ]]; then
        break;
    else
        echo "Could not find Prestashop v$version"
    fi
done

echo "Downloading PrestaShop $version, this may take a while ...";

download_url=$(echo $release | grep "browser_download_url.*zip" | cut -d '"' -f 4)

curl -s -L -o `slugify $1`.zip "$download_url"
unzip -qq -o `slugify $1`.zip -d `slugify $1`
rm -f `slugify $1`.zip

cd `slugify $1`

echo "Expanding PrestaShop, this may take a while ...";

unzip -qq -o prestashop.zip -d .
rm -f prestashop.zip 2> /dev/null
