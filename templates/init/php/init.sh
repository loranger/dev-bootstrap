#!/usr/bin/env sh

echo "Creating “$1” PHP project"

mkdir -p "`slugify $1`/src"

cd `slugify $1`

composer init --name=`whoami`/`slugify $1` --no-interaction; composer config minimum-stability stable
