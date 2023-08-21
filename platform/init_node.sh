#!/bin/bash

# Update the package database
sudo apt-get update

# Install dependencies
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | sudo apt-key add -

# Set up the stable Docker repository for arm64
echo "deb [arch=arm64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the package database with the new repo
sudo apt-get update

# Install Docker CE
sudo apt-get install -y docker-ce

# Start the Docker daemon
sudo systemctl enable docker
sudo systemctl start docker

# Add the current user to the Docker group to allow non-root usage
sudo usermod -aG docker $USER

# Initialize Docker swarm
sudo docker swarm init

# Print out the join token for any worker nodes
echo "To add a worker to this swarm, use the following command:"
# sudo docker swarm join-token worker | grep "docker swarm join"

