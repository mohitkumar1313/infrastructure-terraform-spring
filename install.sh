#!/bin/bash

# Update package lists
sudo apt update -y
sudo apt-get install -y curl unzip wget

# Install OpenJDK 17
sudo apt install openjdk-17-jdk -y

# Install prerequisites for Docker
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y

# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Set up the stable repository for Docker
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package lists again to include Docker's repository
sudo apt update -y

# Install Docker
sudo apt install docker-ce docker-ce-cli containerd.io -y

# Enable and start Docker service
sudo systemctl enable docker
sudo systemctl start docker

# Add the ubuntu user to the docker group (so you can run Docker without sudo)
sudo usermod -aG docker ubuntu

wget https://releases.hashicorp.com/terraform/1.5.5/terraform_1.9.5_linux_amd64.zip
unzip terraform_1.9.5_linux_amd64.zip
sudo mv terraform /usr/local/bin/

# Print versions to confirm installations
java -version
docker --version

