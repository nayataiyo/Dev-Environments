# dev_rails

![Ruby_On_Rails_Logo svg](https://user-images.githubusercontent.com/5633085/101983216-dfba9f80-3cbc-11eb-9c02-d406eaba9cd3.png)

- docker images

  - rails-nginx
    - nginx 1.27.3
  - rails-app
    - ruby:3.3.6 (puma)
  - node:16 (yarn)
  - rails-db
    - mysql:8.0.28
  - rails-redis

- git clone or fork

```
mkdir -p ~/Dev Environments/rails
cd ~/Dev Environments/rails
git clone git@github.com:nayataiyo/menta.git
```

- add localhost /etc/hosts

```
sudo vim /etc/hosts
127.0.0.1 dev-rails.techbull.cloud
```

- docker run

```
cd rails
cp .env.example .env
cd docker-dev
docker-compose up -d
```

- app deploy

```
docker exec -it rails-app bash

rails db:migrate
```

- Access

![image (54)](https://github.com/user-attachments/assets/b3452a97-6f61-46fa-9e8e-3cadf31e3cec)

http://dev-rails.techbull.cloud/

- DB login

```
docker exec -it rails-app bash
mysql -u root -h db -p
```

- redis login

```
docker exec -it rails-redis bash
redis-cli -h redis

```

## How to download Rails app

```
bundle exec rails new app
```
