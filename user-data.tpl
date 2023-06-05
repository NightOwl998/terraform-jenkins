#! /bin/bash
sudo apt-get update -y 
sudo apt-get install \
        ca-certificates \
        curl gnupg \
        lsb-release \
        git \
        binutils -y

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


mkdir /home/ubuntu/jenkins_home
sudo chown ubuntu /home/ubuntu/jenkins_home
sudo chgrp ubuntu /home/ubuntu/jenkins_home


cat > /home/ubuntu/docker-compose.yml <<EOF
---
version : '3'
services:
   jenkins:
     container_name: my_jenkins
     image: jenkins/jenkins
     ports:
       - "8080:8080"
     volumes:
       - ./jenkins_home:/var/jenkins_home
     restart: always
...
EOF




sudo git clone https://github.com/aws/efs-utils
cd efs-utils 
sudo ./build-deb.sh 
sudo apt-get -y install ./build/amazon-efs-utils*deb
sudo mount -t efs ${aws_efs_id}:/ /home/ubuntu/jenkins_home
sudo chown ubuntu /home/ubuntu/jenkins_home
sudo chgrp ubuntu /home/ubuntu/jenkins_home
echo " all is mounted " >> log.txt

cd /home/ubuntu 
docker-compose up -d
echo " jenkins up and running" >> log.txt

