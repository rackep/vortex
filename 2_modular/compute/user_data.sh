#!/bin/bash

## Configure cluster name using the template variable ${ecs_cluster_name}

echo ECS_CLUSTER='${ecs_cluster_name}' >> /etc/ecs/ecs.config

# yum update -y
# yum install -y httpd
# systemctl start httpd
# systemctl enable httpd

# echo "<h1>Hello from $(hostname -f)</h1>" > /var/www/html/index.html



#! /bin/sh
yum update -y
yum install -y docker
service docker start
usermod -a -G docker ec2-user
chkconfig docker on
# docker run -d -p 8080:80 cobaninboban/info

curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

cat << EOF > /home/ec2-user/docker-compose.yaml
version: '3.9'

services:
  frontend:
    image: micic/vortexwest:frontend
    container_name: frontend
    ports:
      - "80:80"
    depends_on:
      - backend
    
  backend:
    image: micic/vortexwest:backend
    container_name: backend
    command: >
      sh -c "
        python manage.py migrate &&
        python manage.py runserver 0.0.0.0:8000 
      "
    ports:
      - "8000:8000"
    environment:
      - POSTGRES_HOST=db
    depends_on:
      - db

  db:
    image: postgres:latest
    restart: always
    container_name: db
    ports:
      - 5432:5432
    volumes:
      - db-data:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=0000
      - POSTGRES_DB=postgres
      - POSTGRES_PORT=5432

  pgadmin:
    image: dpage/pgadmin4
    container_name: demo-pgadmin #you can change this
    depends_on:
      - db
    ports:
      - "8080:80"
    environment:
      PGADMIN_DEFAULT_EMAIL: pgadmin4@pgadmin.org
      PGADMIN_DEFAULT_PASSWORD: root
    restart: always

volumes:
  db-data:
EOF

docker-compose up -d -f /home/ec2-user/docker-compose.yaml