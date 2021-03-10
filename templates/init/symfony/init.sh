#!/usr/bin/env sh

echo "Creating “$1” Symfony project"

composer create-project symfony/website-skeleton `slugify $1`

cd `slugify $1`
