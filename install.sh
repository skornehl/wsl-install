#!/bin/bash
set -x

export LINUX_USER=skornehl
export KEEP_ZSHRC='yes'

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
        zip \
        python3-pip 

mkdir -p ${HOME}/bin

#### 1password
curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | sudo tee /etc/apt/sources.list.d/1password.list
sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
sudo apt update && sudo apt install 1password-cli

#### AWSCLI & saml2aws
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# saml2aws_version=$(curl -fsSL -o /dev/null -w "%{url_effective}" https://github.com/Versent/saml2aws/releases/latest | xargs basename)
# wget https://github.com/Versent/saml2aws/releases/download/${saml2aws_version}/saml2aws_${saml2aws_version:1}_linux_amd64.tar.gz
# tar -xzvf saml2aws_${saml2aws_version:1}_linux_amd64.tar.gz -C ~/bin
# chmod u+x ~/bin/saml2aws
# sudo apt-get purge --auto-remove dbus-x11 -y

#### Docker
###### See https://dev.to/felipecrs/simply-run-docker-on-wsl2-3o8
sudo touch /etc/fstab
sudo update-alternatives --set iptables /usr/sbin/iptables-legacy
sudo update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy

sudo apt-get remove docker docker-engine docker.io containerd runc
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --yes --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo groupadd docker || true
sudo usermod -aG docker ${LINUX_USER}

#### Docker Compose
# Finds the latest version
compose_version=$(curl -fsSL -o /dev/null -w "%{url_effective}" https://github.com/docker/compose/releases/latest | xargs basename)
# Downloads the binary to the plugins folder
curl -fL --create-dirs -o ~/.docker/cli-plugins/docker-compose \
    "https://github.com/docker/compose/releases/download/${compose_version}/docker-compose-linux-$(uname -m)"
# Assigns execution permission to it
chmod +x ~/.docker/cli-plugins/docker-compose
# Finds the latest version
switch_version=$(curl -fsSL -o /dev/null -w "%{url_effective}" https://github.com/docker/compose-switch/releases/latest | xargs basename)
# Downloads the binary
sudo curl -fL -o /usr/local/bin/docker-compose \
    "https://github.com/docker/compose-switch/releases/download/${switch_version}/docker-compose-linux-$(dpkg --print-architecture)"
# Assigns execution permission to it
sudo chmod +x /usr/local/bin/docker-compose

#### Kubernetes 
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-add-repository -y "deb https://apt.kubernetes.io/ kubernetes-xenial main" 
sudo apt-get install -y kubectl

curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.12.0/kind-linux-amd64
chmod +x ./kind
mv ./kind /home/${LINUX_USER}/bin/kind

#### Terraform
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository -y "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt install -y terraform

#### AWS 
pip install awscli 

#### Ansible 
pip install ansible 

#### Workspace 
mkdir -p ${HOME}/workspace
cd ${HOME}/workspace
git clone https://github.com/skornehl/wsl-install.git
cp -pr wsl-install/zshrc ${HOME}/.zshrc

#### SSH
mkdir ${HOME}/.ssh
cp /mnt/c/Users/sebas/workspace/ssh/* ${HOME}/.ssh
sudo chown -R skornehl. ${HOME}/.ssh
sudo chmod -R 700 ${HOME}/.ssh
ssh-add ${HOME}/.ssh/id_ed25519
ssh-add ${HOME}/.ssh/id_rsa

#### Git
git config --global user.email "sebastian.kornehl@codecentric.de"
git config --global user.name "Sebastian Kornehl"

#### ArgoCD
sudo curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo chmod +x /usr/local/bin/argocd

#### OH MY ZSH
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
