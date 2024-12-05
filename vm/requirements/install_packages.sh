#!/bin/bash

# Update the system
sudo dnf update -y

# Install Git, Vim, and dependencies for Node.js
sudo dnf install -y git vim

# Install Node.js (using the NodeSource repository for the latest version)
curl -sL https://rpm.nodesource.com/setup_18.x | sudo -E bash -
sudo dnf install -y nodejs


# Add the MongoDB repository (before installation)
echo "[mongodb-org-6.0]
name=MongoDB 6.0 Repository
baseurl=https://repo.mongodb.org/yum/amazon/2/mongodb-org/6.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-6.0.asc" | sudo tee /etc/yum.repos.d/mongodb-org-6.0.repo

# Install MongoDB
sudo dnf install -y mongodb-org

# Enable and start MongoDB service
sudo systemctl enable --now mongod

# Install npm dependencies:
npm install ../app/backend --no-bin-links # Symlinks is not working properly between the host and the VM volume.

# Verify installations
git --version
vim --version
node --version
npm --version
mongod --version
