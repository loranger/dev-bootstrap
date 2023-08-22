# Docker

## Install

Install [docker](https://docs.docker.com/get-docker/) and [docker-compose](https://docs.docker.com/compose/install/)

## Setup

Copy example files

```shell
cp .env.example .env
cp docker-compose.example docker-compose.yml
```

Customize .env file regarding your environment setup (`APP_DOMAIN`, mainly)

```
...
APP_DOMAIN=project.docker
...
```

Define the same value in your `/etc/hosts` file.  This is **not required** if you use [traefik](https://traefik.io/) reverse proxy (cf [nginx](#nginx)).

```
127.0.0.1   project.docker	www.project.docker
127.0.0.1   meilisearch.project.docker	adminer.project.docker
127.0.0.1   mailhog.project.docker	maildev.project.docker
```

Create the virtual network used by the container (and by traefik)

```shell
 docker network create web
```



## Run

Run the whole stack

```shell
docker-compose up
```

Note: If not exists, the PHP-FPM image need to be built. This takes few minutes.



### First run

On the very first run, you'll need to play extra steps

#### Application key

Generate the application key

```shell
docker-compose run --rm artisan key:generate
```

#### Packages
Install the dependencies

```shell
docker-compose run --rm composer install
docker-compose run --rm npm install
```

#### Migrations

Run the database migrations

```shell
docker-compose run --rm artisan migrate
```

#### Assets

Compile public assets (js, css)

```shell
docker-compose run --rm npm run dev
```

You're done



### Profiles

If you need extra tools such as scheduler, memcached, etc… launch the container using the corresponding profiles

```shell
docker-compose --profile adminer --profile mail up
```



### Images

The website container is composed by the following images

#### nginx

The [nginx](https://www.nginx.com/) webserver, available in its latest version for [alpine](https://alpinelinux.org/). Apache 2.4 is also available, but commented in the docker-compose file.

The website should be reachable using the `APP_DOMAIN` value defined in the `.env` file on its port 80.

The container should be auto discovered by a local traefik, using the `web` network. If you don't use such a reverse proxy, do not forget to add the domain definition in your `/etc/hosts` file. (cf [Setup](#Setup))

#### php-fpm

Tailored for laravel, using the latest official [php](https://www.php.net/) image.

#### mariadb

The open source relational database, forked from mysql: [mariadb](https://mariadb.org/).

#### composer

Based on the previous php-fpm image, useful for interact with app packages

```shell
docker-compose run --rm composer require famous/package
```

#### artisan

Based on php-fpm image, provide a cli access to app

```shell
docker-compose run --rm artisan key:generate
```

#### scheduler

Simple crontab build on the php-fpm image, launch a `artisan schedule:run` every minute.

Profile: `scheduler`

#### npm

Node wrapper for javascript packages as a cli tool

```shell
docker-compose run --rm npm install
```

#### redis

[Redis](https://redis.io/) cache engine

Profile: `redis`

#### memcached

[Memcached](https://memcached.org/) cache engine

Profile: `redis`

#### meilisearch

[Meilisearch](https://www.meilisearch.com/) is a lightweight search engine supported by [scout](https://laravel.com/docs/scout)

Profile: `meilisearch`

#### mailhog / maildev

[Mailhog](https://github.com/mailhog/MailHog) and [maildev](http://maildev.github.io/maildev/) are both a simple smtp server providing a simple interface in order to debug emails

Profile: `mail`

#### adminer

[Adminer](https://www.adminer.org/) is a simple database management interface allowing to interact with the app database

Profile: `adminer`

