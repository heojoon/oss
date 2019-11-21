#!/bin/bash

#
# Install Base Environment
# OS : CentOS 7.4 in VMware
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
sudo yum -y install docker-ce

# 1.2.3. Start Docker
sudo systemctl start docker


#
# 2. Docker Composer Install for CentOS
#
# Ref : https://docs.docker.com/compose/install/

# 2.1. Run this command to download the latest version of Docker Compose:

sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
 
# 2.2. Apply executable permissions to the binary:

sudo chmod +x /usr/local/bin/docker-compose

# 2.3. Command-line completion
sudo curl -L https://raw.githubusercontent.com/docker/compose/1.23.1/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose

cat >> ~/.bash_profile << EOF

if [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
    . /opt/local/etc/profile.d/bash_completion.sh
fi
EOF


# Finish


