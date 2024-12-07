#!/bin/bash

# Update the system
sudo dnf update -y

# Install Git, Vim, and dependencies for Node.js
sudo dnf install -y git vim wget curl gnupg

# Installing docker:
sudo dnf install -y dnf-utils device-mapper-persistent-data lvm2
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
newgrp docker


# Installing Google Bazel building tool:
curl -fsSL https://bazel.build/bazel-release.pub.gpg | sudo tee /usr/share/keyrings/bazel-archive-keyring.gpg
sudo dnf config-manager --add-repo https://storage.googleapis.com/download.bazel.build/rpm/stable.repo
sudo dnf install -y dnf-plugins-core
sudo dnf copr enable vbatts/bazel -y
sudo dnf install -y bazel4
bazel --version


# Installing k3s:
# Downloading the installation script:
curl -sfL https://get.k3s.io | sh -

# Validating that k3s is up and running:
sudo systemctl status k3s

# Configuring non root access to k3s:
sudo cp /etc/rancher/k3s/k3s.yaml /home/$(whoami)/.kube/config
sudo chown $(whoami):$(whoami) /home/$(whoami)/.kube/config

k3s --version
# Giving vagrant user the permissions to k3s config file
sudo chmod 644 /etc/rancher/k3s/k3s.yaml

# ====================================== In order to run the app directly from the VM - without cluster =================================

# Install Node.js (using the NodeSource repository for the latest version)
# curl -sL https://rpm.nodesource.com/setup_18.x | sudo -E bash -
# sudo dnf install -y nodejs


# # Add the MongoDB repository (before installation)
# echo "[mongodb-org-6.0]
# name=MongoDB 6.0 Repository
# baseurl=https://repo.mongodb.org/yum/amazon/2/mongodb-org/6.0/x86_64/
# gpgcheck=1
# enabled=1
# gpgkey=https://www.mongodb.org/static/pgp/server-6.0.asc" | sudo tee /etc/yum.repos.d/mongodb-org-6.0.repo

# # Install MongoDB
# sudo dnf install -y mongodb-org

# # Enable and start MongoDB service
# sudo systemctl enable --now mongod

# # Install npm dependencies:
# npm install ../app/backend --no-bin-links # Symlinks is not working properly between the host and the VM volume.

# ====================================== In order to run the app directly from the VM - without cluster =================================


# Verify installations
git --version
vim --version
# node --version
# npm --version
# mongod --version
docker --version
bazel --version
k3s --version
