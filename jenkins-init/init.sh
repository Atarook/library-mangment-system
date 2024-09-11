#!/bin/bash


## Start
echo "Start"

########################################################################
## Installing Jenkins

wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
apt-get update
apt-get install jenkins -y



apt update
apt install fontconfig openjdk-17-jre -y

## Configuring Jenkins
service jenkins restart

########################################################################


## Installing Nginx
apt install nginx -y

## Configuring Nginx
echo "user www-data;
worker_processes auto;
pid /run/nginx.pid;
error_log /var/log/nginx/error.log;
include /etc/nginx/modules-enabled/*.conf;
events {
        worker_connections 768;
}
http {
  server {
        server_name localhost;
        listen 80;
        location / {
                proxy_pass http://localhost:8080;
        }
  }
}" > /etc/nginx/nginx.conf
service nginx restart

##########################################################################

## Installing Docker

sudo apt-get update
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

chmod 777 /var/run/docker.sock

groupadd docker
gpasswd -a jenkins docker
gpasswd -a ubuntu docker



## Installing PIP
apt install python3-pip -y


## Installing kubectl
snap install kubectl --classic

## Installing Terraform 

snap install terraform --classic

## Installing AWS CLI
apt install curl unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

## Installing SonarQube
docker run -d --name sonarqube-db -e POSTGRES_USER=sonar -e POSTGRES_PASSWORD=sonar -e POSTGRES_DB=sonarqube postgres:alpine

docker run -d --name sonarqube -p 9000:9000 --link sonarqube-db:db -e SONAR_JDBC_URL=jdbc:postgresql://db:5432/sonarqube -e SONAR_JDBC_USERNAME=sonar -e SONAR_JDBC_PASSWORD=sonar sonarqube

## Catch All service In System
ls /lib/systemd/system/[j-d-n]*.service


## Checking Status
service nginx status
service jenkins status
service docker status
kubectl --version
terraform --version
python3 --version
pip3 --version

## Finish
echo "Finished"

