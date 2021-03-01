#!/usr/bin/env sh

echo "Creating “$1” Symfony project"

mkdir `slugify $1`
cd `slugify $1`
composer create-project symfony/website-skeleton App

