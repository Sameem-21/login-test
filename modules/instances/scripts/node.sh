#!/bin/bash
set -e
exec > /var/log/node_setup.log 2>&1

echo "⚙️ Setting up Node.js app..."

# Install Node.js (if not already installed)
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Navigate to app directory
cd /home/ubuntu/login-app

# Install dependencies
npm install

# Start app in background
nohup node server.js > /home/ubuntu/server.log 2>&1 &

echo "✅ Node.js app started."
