#!/usr/bin/env sh

echo "Creating “$1” NuxtJS project"

(checkRequirement "npm") || return $?

npx nuxi@latest init `slugify $1`

cd `slugify $1`

# npm run dev -- -o
