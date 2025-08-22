#!/bin/bash
set -e
exec > /var/log/nginx_install.log 2>&1

echo "🌐 Installing Nginx..."

sudo apt-get update
sudo apt-get install -y nginx

# Sample config (adjust paths as needed)
cat <<EOF | sudo tee /etc/nginx/sites-available/default
server {
    listen 80;
    server_name _;

    location / {
        root /home/ubuntu/login-app;
        index index.html;
    }

    location /login {
        proxy_pass http://localhost:3000;
    }
}
EOF

sudo nginx -t
sudo systemctl restart nginx

echo "✅ Nginx installed and configured."
