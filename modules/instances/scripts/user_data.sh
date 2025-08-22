# #!/bin/bash
# exec > /var/log/user_data.log 2>&1
# set -e

# # Run SQL Server setup
# bash D:\GITHUB_Folder\login-test\modules\instances\scripts\sql.sh

# # Run Nginx setup
# bash D:\GITHUB_Folder\login-test\modules\instances\scripts\nginx.sh

# # Inject DB credentials into .env before Node.js setup
# APP_DIR="/home/ubuntu/login-app"

# cat <<EOF > $APP_DIR/.env
# DB_USER=${username}
# DB_PASS=${password}
# DB_HOST=${db_host}
# EOF

# chown ubuntu:ubuntu $APP_DIR/.env
# chmod 600 $APP_DIR/.env

# echo ".env file created at $APP_DIR/.env"

# # Now run Node.js setup
# bash D:\GITHUB_Folder\login-test\modules\instances\scripts\node.sh

#!/bin/bash
exec > /var/log/user_data.log 2>&1
set -e
set -x

# Update system
apt-get update -y

# Install MSSQL tools
curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list | tee /etc/apt/sources.list.d/mssql-release.list
apt-get update -y
ACCEPT_EULA=Y apt-get install -y msodbcsql17 mssql-tools

# Add MSSQL tools to PATH
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> /etc/profile.d/mssql-tools.sh
source /etc/profile.d/mssql-tools.sh

# # Install Node.js (v18)
# curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
# apt-get install -y nodejs

# # Install Nginx
# apt-get install -y nginx
# systemctl enable nginx
# systemctl start nginx

# # Set up app directory
# APP_DIR="/home/ubuntu/login-app"
# mkdir -p $APP_DIR
# chown ubuntu:ubuntu $APP_DIR

# # Inject DB credentials into .env
# cat <<EOF > $APP_DIR/.env
# DB_USER=admin
# DB_PASS=Passw0rd!23
# DB_HOST=sam-db-instance.cz8eomwyg3n0.ap-south-1.rds.amazonaws.com
# EOF

# chmod 600 $APP_DIR/.env
# chown ubuntu:ubuntu $APP_DIR/.env

# # Deploy frontend (index.html)
# cat <<EOF > $APP_DIR/index.html
# <!DOCTYPE html>
# <html>
# <head><title>Login</title></head>
# <body>
#   <h2>Login Page</h2>
#   <form method="POST" action="/login">
#     <input type="text" name="username" placeholder="Username" required />
#     <input type="password" name="password" placeholder="Password" required />
#     <button type="submit">Login</button>
#   </form>
# </body>
# </html>
# EOF

# # Sample Node.js backend
# cat <<EOF > $APP_DIR/server.js
# const express = require('express');
# const bodyParser = require('body-parser');
# require('dotenv').config();

# const app = express();
# app.use(bodyParser.urlencoded({ extended: true }));

# app.post('/login', (req, res) => {
#   const { username, password } = req.body;
#   console.log(\`Login attempt: \${username}\`);
#   res.send('Login received');
# });

# app.listen(3000, () => {
#   console.log('Server running on port 3000');
# });
# EOF

# # Install dependencies
# npm install express body-parser dotenv

# # Start Node.js app
# nohup node $APP_DIR/server.js > $APP_DIR/server.log 2>&1 &

# # Configure Nginx to serve index.html and proxy /login
# cat <<EOF > /etc/nginx/sites-available/default
# server {
#     listen 80;
#     server_name _;

#     location / {
#         root $APP_DIR;
#         index index.html;
#     }

#     location /login {
#         proxy_pass http://localhost:3000;
#     }
# }
# EOF

# nginx -t && systemctl reload nginx
