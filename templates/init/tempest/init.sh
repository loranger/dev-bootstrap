#!/usr/bin/env sh

echo "Creating “$1” Tempest project"

composer create-project --prefer-dist tempest/app `slugify $1`

cd `slugify $1`

composer init --name=`whoami`/`slugify $1` --no-interaction
