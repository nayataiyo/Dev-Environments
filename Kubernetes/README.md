# Wordpress By Kubernetes

![Kubernetes-logo-1.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3904736/e98821d8-58e9-3d7d-8083-bd701458b8f0.png)

## Versions
- kubectl version
```
Client Version: v1.30.5
Kustomize Version: v5.0.4-0.20230601165947-6ce0bf390ce3
Server Version: v1.30.5
```

## docker base images
- web
  - nginx:1.27.3-alpine
- app
  - php:8.3-fpm-alpine
- db
  - mysql:8.0.28

## Directory

```
(~/Desktop/menta/Kubernetes)$ ls -a
.          ..         .gitignore README.md  docker     k8s        wordpress

tree docker
docker
├── app
│   ├── Dockerfile
│   └── php
│       ├── php-fpm.conf
│       ├── php.ini
│       └── www.conf
├── mysql
│   ├── Dockerfile
│   ├── db_data #ommision
│   ├── my.cnf
│   └── mysql.gpg
└── nginx
    ├── Dockerfile
    └── conf
        ├── dev-k8s.techbull.cloud.conf
        └── nginx.conf

tree k8s
k8s
├── app.yml
├── ingress.yml
├── mysql.yml
└── secrets.yml
```

## Several Settings

- git clone or fork

```
mkdir -p ~/Desktop/menta
cd ~/Desktop/menta
git clone git@github.com:nayataiyo/menta.git
```

- add localhost /etc/hosts

```
sudo vim /etc/hosts
127.0.0.1 dev-k8s.techbull.cloud
```

- setting wp-config.php

```
cd Kubernetes
cp wordpress/wp-config-sample.php wordpress/wp-config.php
```

- WordPress official random key generate

https://api.wordpress.org/secret-key/1.1/salt/

copy & paste

```
define( 'AUTH_KEY',         'put your unique phrase here' );
define( 'SECURE_AUTH_KEY',  'put your unique phrase here' );
define( 'LOGGED_IN_KEY',    'put your unique phrase here' );
define( 'NONCE_KEY',        'put your unique phrase here' );
define( 'AUTH_SALT',        'put your unique phrase here' );
define( 'SECURE_AUTH_SALT', 'put your unique phrase here' );
define( 'LOGGED_IN_SALT',   'put your unique phrase here' );
define( 'NONCE_SALT',       'put your unique phrase here' );
```

## Build Docker image

- check docker context

```
(~/Desktop/menta/Kubernetes/docker/nginx)$ docker build . -t Kubernetes/nginx:v1.0.0
(~/Desktop/menta/Kubernetes)$ docker build -t issue22/app:v1.0.0 -f docker/app/Dockerfile .
(~/Desktop/menta/Kubernetes/docker/mysql)$ docker build . -t Kubernetes/mysql:v1.0.0
```

## Setting Kubernetes

- check use-context and create your namespace

```
kubectl config get-contexts
kubectl config use-context docker-desktop
kubectl create namespace dev-techbull-k8s
```

- make secrets.yaml to create secret/mysql-secret

By environment variables, pass informations to containers for access databases
In secrets.yaml, such values are encoded by base64

```
echo -n "wordpress" | base64
d29yZHByZXNz
```

- secrets.yaml

DB_ : use for wp-config.php
MYSQL_ : use for mysql container

```
apiVersion: v1
kind: Secret
metadata:
  name: mysql-secret
type: Opaque
data:
  MYSQL_DATABASE: (string encoded by base64)
  MYSQL_USER: (string encoded by base64)
  MYSQL_PASSWORD: (string encoded by base64)
  MYSQL_ROOT_PASSWORD: (string encoded by base64)
```

- create k8s resources

create Ingress-NGINX controller
reference: https://github.com/kubernetes/ingress-nginx

I chose v1.11.3
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.11.3/deploy/static/provider/cloud/deploy.yaml
```

```
(~/Desktop/menta/Kubernetes/k8s)$ kubectl -n dev-techbull-k8s apply -f secrets.yml
(~/Desktop/menta/Kubernetes/k8s)$ kubectl -n dev-techbull-k8s apply -f ingress.yml
(~/Desktop/menta/Kubernetes/k8s)$ kubectl -n dev-techbull-k8s apply -f app.yml
(~/Desktop/menta/Kubernetes/k8s)$ kubectl -n dev-techbull-k8s apply -f mysql.yml
```

## Check Resource

```
kubectl -n dev-techbull-k8s get ingress,secret,service,deployment,statefulset,pod,pvc
NAME                                  CLASS   HOSTS                    ADDRESS     PORTS   AGE
ingress.networking.k8s.io/wordpress   nginx   dev-k8s.techbull.cloud   localhost   80      18m

NAME                  TYPE     DATA   AGE
secret/mysql-secret   Opaque   4      18m

NAME                TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
service/mysql       ClusterIP   None           <none>        3306/TCP   18m
service/wordpress   ClusterIP   10.110.19.47   <none>        80/TCP     18m

NAME                        READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/wordpress   1/1     1            1           18m

NAME                     READY   AGE
statefulset.apps/mysql   1/1     18m

NAME                             READY   STATUS    RESTARTS   AGE
pod/mysql-0                      1/1     Running   0          18m
pod/wordpress-57cc98c747-dsvd9   2/2     Running   0          18m

NAME                                                        CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                                 STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE     
persistentvolume/pvc-61ecd36a-c3c2-4686-89aa-3f91cdc38566   10Gi       RWO            Delete           Bound    dev-techbull-k8s/mysql-data-mysql-0   hostpath       <unset>                          18m     
```

## Access

http://dev-k8s.techbull.cloud/

Enjoy WordPress Life!

## Tips for troubleshooting

```
kubectl -n <namespace> describe <resource>
kubectl -n <namespace> log <pod_name>
kubectl -n <namespace> exec <pod_name> -c <container_name> -- sh
```

In Container(after exec)
```
cat <log_file>
cat /etc/resolv.conf
nslookup <service_name>
env | grep 'DB\|MYSQL'
```

For invalid env settings, I couldn't access databases, so I wanted to initialize databases.
When initialize databases, you need to delete not only pod/mysql-0 but also persistentvolumeclaim/mysql-data-mysql-0.
```
kubectl -n <namespace> delete pvc mysql-data-mysql-0
kubectl -n <namespace> delete pod mysql-0
```

check docker-entrypoint.sh in official container image.
