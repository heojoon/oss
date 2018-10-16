#!/bin/bash

#
# Install Base Environment
# OS : CentOS 7.2 in VMware
#
# Ref : https://docs.docker.com/install/linux/docker-ce/centos/ 

# 1. Docker Install for Centos

# Subject : Docker CE Stable version install

# 1.1. Unistall Old docker 
sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine

# 1.2. Install Docker CE

# 1.2.1. Set up the repository
sudo yum -y install -y yum-utils \
  device-mapper-persistent-data \
  lvm2

sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

# 1.2.2. Install Docker CE
sudo yum install docker-ce

# 1.2.3. Start Docker
sudo systemctl start docker


    

