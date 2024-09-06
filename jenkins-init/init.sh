#!/bin/bash

## installing jenkins

sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins -y



sudo apt update
sudo apt install fontconfig openjdk-17-jre -y

## Configuring jenkins

# sudo service jenkins stop 

# sudo chown ubuntu /var/lib/jenkins/config.xml

# echo "<?xml version='1.1' encoding='UTF-8'?>
# <hudson>
#   <disabledAdministrativeMonitors/>
#   <version>2.462.2</version>
#   <numExecutors>2</numExecutors>
#   <mode>NORMAL</mode>
#   <useSecurity>true</useSecurity>
#   <authorizationStrategy class="hudson.security.AuthorizationStrategy$Unsecured"/>
#   <securityRealm class="hudson.security.SecurityRealm$None"/>
#   <disableRememberMe>false</disableRememberMe>
#   <projectNamingStrategy class="jenkins.model.ProjectNamingStrategy$DefaultProjectNamingStrategy"/>
#   <workspaceDir>${JENKINS_HOME}/workspace/${ITEM_FULL_NAME}</workspaceDir>
#   <buildsDir>${ITEM_ROOTDIR}/builds</buildsDir>
#   <jdks/>
#   <viewsTabBar class="hudson.views.DefaultViewsTabBar"/>
#   <myViewsTabBar class="hudson.views.DefaultMyViewsTabBar"/>
#   <clouds/>
#   <scmCheckoutRetryCount>0</scmCheckoutRetryCount>
#   <views>
#     <hudson.model.AllView>
#       <owner class="hudson" reference="../../.."/>
#       <name>all</name>
#       <filterExecutors>false</filterExecutors>
#       <filterQueue>false</filterQueue>
#       <properties class="hudson.model.View$PropertyList"/>
#     </hudson.model.AllView>
#   </views>
#   <primaryView>all</primaryView>
#   <slaveAgentPort>-1</slaveAgentPort>
#   <label></label>
#   <crumbIssuer class="hudson.security.csrf.DefaultCrumbIssuer">
#     <excludeClientIPFromCrumb>false</excludeClientIPFromCrumb>
#   </crumbIssuer>
#   <nodeProperties/>
#   <globalNodeProperties/>
#   <nodeRenameMigrationNeeded>false</nodeRenameMigrationNeeded>" > /var/lib/jenkins/config.xml


sudo service jenkins restart

## Installing nginx
sudo apt install nginx -y
sudo chown ubuntu:ubuntu /etc/nginx/nginx.conf
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
sudo service nginx restart

## installing docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh ./get-docker.sh --dry-run

sudo groupadd docker
sudo gpasswd -a $USER docker


## installing pip
sudo apt install python3-pip -y


