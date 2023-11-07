#!/bin/bash

# Vagrant provisioning script for Ubuntu 20.04 LTS

# Docker installation

sudo apt-get update
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

sudo usermod -aG docker vagrant


# Kubectl install

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client --output=yaml


# Install Git
sudo apt-get install -y git


# Adding aliases and env vars
VAGRANT_HOME=/home/vagrant
echo "alias k=kubectl" | sudo tee -a $VAGRANT_HOME/.bashrc
echo "export KUBECONFIG=$VAGRANT_HOME/k8s/oidc-kube-config.yml" | sudo tee -a $VAGRANT_HOME/.bashrc

git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.slog "log --graph --all --topo-order --pretty='format:%h %ai %s%d (%an)'"

