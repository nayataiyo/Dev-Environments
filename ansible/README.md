# Zabbix-grafana with Ansible

![ansible_icon_132595.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3904736/39e758ca-49b7-f4b7-69ec-887720e1f9b1.png)

# Environment Overview

- WordPress Stack:
  - Web Server: Nginx (latest)
  - PHP Version: 8.3
  - Database: MySQL 8.0.40

- Monitoring Stack
  - Zabbix Version: 5.0.45
  - Grafana Version: 9.5.3

- Access URL
  - Web Access: [http://hostname/](http://dev.menta.me/)

#  playbook run
```sh
$ ansible-playbook playbook.yml
```
# Service Status Checks

- Nginx Status Check
```sh
sudo nginx -t
sudo systemctl status nginx
```

- PHP Status Check
```sh
php -v
php-fpm -t
sudo systemctl status php-fpm.service
```

- Database Login
```sh
mysql -u root -h db -p
```

- Zabbix Status Check
```sh
sudo systemctl status zabbix-agent.service
sudo systemctl status zabbix-server.service
```
