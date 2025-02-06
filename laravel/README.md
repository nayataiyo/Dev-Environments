# dev_laravel

<p align="center"><a href="https://laravel.com" target="_blank"><img src="https://raw.githubusercontent.com/laravel/art/master/logo-lockup/5%20SVG/2%20CMYK/1%20Full%20Color/laravel-logolockup-cmyk-red.svg" width="400" alt="Laravel Logo"></a></p>

-   docker images

    -   laravel-nginx
        -   nginx 1.27.3-alpine
    -   laravel-app
        -   php:8.3-fpm-alpine
        -   Laravel 11.34.2
    -   laravel-db
        -   mysql:8.0.28
    -   laravel-redis
        -   redis:latest

-   git clone or fork

```
mkdir -p ~/Dev Environments/laravel
cd ~/Dev Environments/laravel
git clone git@github.com:nayataiyo/menta.git
```

-   add localhost /etc/hosts

```
sudo vim /etc/hosts
127.0.0.1 dev-laravel.techbull.cloud
```

-   docker run

```
cd laravel
cp .env.example .env
cd docker-dev
docker-compose up -d
```

-   app deploy

```
docker exec -it laravel-app bash

composer install
php artisan key:generate
php artisan config:cache
php artisan migrate
```

-   Access

http://dev-laravel.techbull.cloud/

![スクリーンショット 2024-11-30 185531](https://github.com/user-attachments/assets/bf5dfca5-0c1f-4a5a-ace9-1292ac8bf776)

-   DB login

```
docker exec -it laravel-app bash
mysql -u root -h db -p
```

-   redis login

```
docker exec -it laravel-app bash
redis-cli -h redis
```

## How to download Laravel app

```
composer global require laravel/installer

laravel new app
or
composer create-project --prefer-dist laravel/laravel app
```
