#!/bin/bash

## Configure cluster name using the template variable ${ecs_cluster_name}

echo ECS_CLUSTER='${ecs_cluster_name}' >> /etc/ecs/ecs.config

# yum update -y
# yum install -y httpd
# systemctl start httpd
# systemctl enable httpd

# echo "<h1>Hello from $(hostname -f)</h1>" > /var/www/html/index.html
