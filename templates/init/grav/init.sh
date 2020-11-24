#!/usr/bin/env sh

echo "Creating “$1” Grav project"

composer create-project getgrav/grav `slugify $1`

cd `slugify $1`

bin/gpm install --all-yes admin
