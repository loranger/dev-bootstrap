#!/usr/bin/env sh

echo "Creating “$1” Symfony project"

types=("microservice, console or api" "web application")
PS3="Kind of “$1” project: "
select type in $types;
do
    break;
done

composer create-project symfony/website-skeleton `slugify $1`

cd `slugify $1`

if [[ $REPLY = 2 ]]; then
    composer require webapp
fi
