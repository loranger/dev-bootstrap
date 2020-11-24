#!/usr/bin/env sh

echo "Creating “$1” Laravel project"

# laravel new `slugify $1`
composer create-project --prefer-dist laravel/laravel `slugify $1`

cd `slugify $1`
