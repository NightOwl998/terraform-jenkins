#!/bin/bash
sudo wget https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public
sudo apt-key add public
sudo add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/
sudo apt update
sudo apt install --yes adoptopenjdk-11-hotspot
sudo add-apt-repository --yes ppa:openjdk-r/ppa
sudo apt update
sudo apt install --yes openjdk-11-jdk
sudo apt install --yes golang-go
sudo echo "ubuntu:${password}" | sudo chpasswd
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo systemctl restart sshd 
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo curl -L "https://github.com/docker/compose/releases/download/v2.12.2/docker-compose-$(uname -s)-$(uname -m)"  -o /usr/local/bin/docker-compose
sudo mv /usr/local/bin/docker-compose /usr/bin/docker-compose
sudo chmod +x /usr/bin/docker-compose
sudo usermod -aG docker ubuntu 
sudo su - ubuntu 
sudo groupadd docker 
sudo usermod -aG docker ubuntu
newgrp docker
echo "Docker is installed" >> log.txt