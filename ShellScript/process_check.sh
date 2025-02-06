#!/bin/bash

nginx_process_count=$(pgrep -c nginx)

if [ "$nginx_process_count" -eq 0 ]; then
     echo $nginx_process_count
     echo "nginx is not running" 
     sudo systemctl start nginx 
     echo "nginx is running"
else 
     echo $nginx_process_count   
     echo "nginx is running"
fi
