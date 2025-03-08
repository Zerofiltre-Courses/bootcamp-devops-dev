#!/bin/bash

# Vagrant provisioning script for Ubuntu 20.04 LTS

echo "=========== docker install ==========="

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
sudo apt-get install -y docker-ce docker-ce-cli containerd.io jq docker-compose
sudo usermod -aG docker vagrant

echo "=========== Java install ==========="
sudo apt install -y default-jdk
echo 'export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64' >> ~/.bashrc
source ~/.bashrc
echo $JAVA_HOME
java -version

echo "=========== Maven install ==========="
sudo apt install -y maven
mvn -version



sudo usermod -aG docker vagrant

echo "=========== Kubectl install ==========="

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client --output=yaml


echo "=========== git install ==========="
sudo apt-get install -y git

echo "=========== Git install results =============="
git --version

git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.slog "log --graph --all --topo-order --pretty='format:%h %ai %s%d (%an)'"
git config --global user.email "you@example.com"
git config --global user.name "Your Name"

echo "=========== Krew install =============="

echo "=========== Download Krew =============="
(
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
  KREW="krew-${OS}_${ARCH}" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
  tar zxvf "${KREW}.tar.gz" &&
  ./"${KREW}" install krew
)

## Add directory to your PATH environment variable
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

## Execute krew command
kubectl krew

echo "=========== Helm install =============="

curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm


echo "=========== Adding aliases =============="
VAGRANT_HOME=/home/vagrant
echo "alias k=kubectl" | sudo tee -a $VAGRANT_HOME/.bashrc
echo "export KUBECONFIG=$VAGRANT_HOME/k8s/oidc-kube-config.yml" | sudo tee -a $VAGRANT_HOME/.bashrc


