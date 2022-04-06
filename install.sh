#!/bin/bash

### Create User
# NEW_USER=skornehl
# useradd -m -G sudo -s /bin/bash "$NEW_USER"
# passwd "$NEW_USER"
# tee /etc/wsl.conf <<_EOF
# [user]
# default=${NEW_USER}
# _EOF

sudo apt-get update
sudo apt-get upgrade -y 
sudo apt-get install -y \
        vim \
        curl wget \
        git \
        ca-certificates \
        gnupg \
        apt-transport-https \
        lsb-release \
        golang  \
        zsh \
        awscli \
        python3-pip 

#### Docker
###### See https://dev.to/felipecrs/simply-run-docker-on-wsl2-3o8
sudo apt-get remove docker docker-engine docker.io containerd runc
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor  --yes -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  sudo apt-add-repository -y "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" 
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo groupadd docker
sudo usermod -aG docker skornehl

#### Docker Compose
# Finds the latest version
$ compose_version=$(curl -fsSL -o /dev/null -w "%{url_effective}" https://github.com/docker/compose/releases/latest | xargs basename)
# Downloads the binary to the plugins folder
$ curl -fL --create-dirs -o ~/.docker/cli-plugins/docker-compose \
    "https://github.com/docker/compose/releases/download/${compose_version}/docker-compose-linux-$(uname -m)"
# Assigns execution permission to it
$ chmod +x ~/.docker/cli-plugins/docker-compose
# Finds the latest version
$ switch_version=$(curl -fsSL -o /dev/null -w "%{url_effective}" https://github.com/docker/compose-switch/releases/latest | xargs basename)
# Downloads the binary
$ sudo curl -fL -o /usr/local/bin/docker-compose \
    "https://github.com/docker/compose-switch/releases/download/${switch_version}/docker-compose-linux-$(dpkg --print-architecture)"
# Assigns execution permission to it
$ sudo chmod +x /usr/local/bin/docker-compose

#### Kubernetes 
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-add-repository -y "deb https://apt.kubernetes.io/ kubernetes-xenial main" 
sudo apt-get install -y kubectl

export GO111MODULE=on 
go get sigs.k8s.io/kind@v0.12.0

#### Terraform
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository -y "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt install -y terraform

#### AWS 
pip install awscli 

#### OH MY ZSH
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"