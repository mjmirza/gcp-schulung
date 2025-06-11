#!/bin/bash

# Update the package list and install necessary packages
apt-get update
apt-get install -y curl gnupg

# Install Node.js and npm
curl -sL https://deb.nodesource.com/setup_14.x | bash -
apt-get install -y nodejs

# Install n8n globally
npm install -g n8n

# Create a directory for n8n
mkdir -p /home/n8n/.n8n

# Set up environment variables for n8n
export N8N_PORT=5678
export N8N_HOST=0.0.0.0
export N8N_PROTOCOL=https
export N8N_SSL_CERT=/path/to/your/cert.pem
export N8N_SSL_KEY=/path/to/your/key.pem

# Start n8n
n8n start &

# Enable n8n to start on boot
echo "@reboot root n8n start" >> /etc/crontab