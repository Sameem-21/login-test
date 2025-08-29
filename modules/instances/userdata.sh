#!/bin/bash
exec > /var/log/user_data.log 2>&1
set -e
set -x

# Update system
apt-get update -y

# Install Nginx
apt-get install -y nginx
systemctl enable nginx
systemctl start nginx

# Overwrite default Nginx config to serve custom login page

#!/bin/bash
exec > /var/log/user_data.log 2>&1
set -e
set -x

# Update system
apt-get update -y

# Install Nginx
apt-get install -y nginx
systemctl enable nginx
systemctl start nginx

# Overwrite default Nginx config to serve login page and proxy /submit to Node.js
cat <<'NGINX' | sudo tee /etc/nginx/sites-available/default > /dev/null
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    server_name _;

    root /usr/share/nginx/html;
    index index.html;

    location / {
        try_files /index.html =404;
    }

    location /submit {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
NGINX
#validate and reload nginx
sudo nginx -t && sudo systemctl reload nginx
# cat <<'NGINX' | sudo tee /etc/nginx/sites-available/default > /dev/null
# server {
#     listen 80 default_server;
#     listen [::]:80 default_server;

#     server_name _;

#     root /usr/share/nginx/html;
#     index index.html;

#     location / {
#         # Serve index.html directly for root requests
#         try_files /index.html =404;
#     }
# }
# NGINX

# sudo nginx -t && sudo systemctl reload nginx

# cat <<'NGINX' > /etc/nginx/sites-available/default
# server{
#     listen 80 default_server;
#     listen [::]:80 default_server;

#     server_name _;

#     root /usr/share/nginx/html;
#     index index.html;

#     location / {
#         try_files \$uri \$uri/ =404;
#     }

#     location /login {
#         proxy_pass http://localhost:3000;
#         proxy_set_header Host \$host;
#         proxy_set_header X-Real-IP \$remote_addr;
#         proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
#         proxy_set_header X-Forwarded-Proto \$scheme;
#     }

# }
# NGINX

# Validate and reload Nginx
#nginx -t && systemctl reload nginx


# Deploy login page to Nginx root
cat <<'HTML' > /usr/share/nginx/html/index.html
<!DOCTYPE html>
<html>
<head>
<title>Login</title>
<style>
body {
  font-family: Arial, sans-serif;
  background-color: #f4f4f4;
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
}
.login-container {
  background-color: #fff;
  padding: 30px;
  border-radius: 8px;
  box-shadow: 0 0 10px rgba(0,0,0,0.1);
  width: 300px;
}
h2 {
  text-align: center;
  margin-bottom: 20px;
}
input[type="text"],
input[type="password"] {
  width: 100%;
  padding: 10px;
  margin: 8px 0;
  border: 1px solid #ccc;
  border-radius: 4px;
  box-sizing: border-box;
}
input[type="submit"] {
  width: 100%;
  padding: 10px;
  background-color: #007bff;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}
input[type="submit"]:hover {
  background-color: #0056b3;
}
</style>
</head>
<body>
  <div class="login-container">
    <h2>Login Page</h2>
    <form method="POST" action="/submit">
      <label>Username:</label><input type="text" name="username" >
      <label>Password:</label><input type="password" name="password" >
      <input type="submit" value="Login">
    </form>
  </div>
</body>
</html>
HTML

# Reload Nginx to serve new content
sudo nginx -t && systemctl reload nginx

#server.js

# Install Node.js and dependencies
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs

npm install -g pm2

# Create server.js
cat <<'NODE' > /home/ubuntu/server.js
const express = require('express');
const bodyParser = require('body-parser');
const sql = require('mssql');

const app = express();
const port = 3000;

app.use(bodyParser.urlencoded({ extended: true }));

const config = {
  user: 'admin',
  password: 'Passw0rd!23',
  server: 'sam-db-instance-new-3.cz8eomwyg3n0.ap-south-1.rds.amazonaws.com',
  port: 1433,
  database: 'SamDB',
  options: {
    encrypt: true,
    trustServerCertificate: true
  }
};

app.post('/submit', async (req, res) => {
  const { username, password } = req.body;

  try {
    await sql.connect(config);
    await sql.query`INSERT INTO Users (Username, Password) VALUES (${username}, ${password})`;
    res.send('User data inserted successfully!');
  } catch (err) {
    console.error('SQL error:', err);
    res.status(500).send('Database error');
  } finally {
    await sql.close();
  }
});

app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});
NODE

# Install required Node packages
cd /home/ubuntu
npm init -y
npm install express body-parser mssql

# Start server with PM2
pm2 start /home/ubuntu/server.js --name login-backend
pm2 startup systemd
pm2 save



# Install MSSQL tools (modern key handling)
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/microsoft.gpg
curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list | tee /etc/apt/sources.list.d/mssql-release.list
apt-get update -y
ACCEPT_EULA=Y apt-get install -y msodbcsql17 mssql-tools

# Add MSSQL tools to PATH
# Add MSSQL tools to PATH
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' | sudo tee -a /etc/profile.d/mssql-tools.sh > /dev/null
source /etc/profile.d/mssql-tools.sh


# Wait for RDS SQL Server to be ready (with retry cap)
MAX_RETRIES=30
COUNT=0
until /opt/mssql-tools/bin/sqlcmd -S sam-db-instance-new-3.cz8eomwyg3n0.ap-south-1.rds.amazonaws.com,1433 -U admin -P "Passw0rd!23" -Q "SELECT name FROM sys.databases" > /dev/null 2>&1; do
  echo "Waiting for RDS SQL Server to be ready..."
  sleep 10
  COUNT=$((COUNT+1))
  if [ "$COUNT" -ge "$MAX_RETRIES" ]; then
    echo "Database not ready after $MAX_RETRIES attempts. Exiting."
    exit 1
  fi
done

# Create DB and Users table if not exists
cat <<SQL | /opt/mssql-tools/bin/sqlcmd -S sam-db-instance-new-3.cz8eomwyg3n0.ap-south-1.rds.amazonaws.com,1433 \
  -U admin -P "Passw0rd!23" > /home/ubuntu/sql_output.log
IF DB_ID('SamDB') IS NULL
BEGIN
    CREATE DATABASE SamDB;
END
GO
USE SamDB;
GO
IF OBJECT_ID('Users') IS NULL
BEGIN
    CREATE TABLE Users (
        ID INT PRIMARY KEY IDENTITY(1,1),
        Username NVARCHAR(50),
        Password NVARCHAR(100)
    );
END
GO
SQL

echo "SQL execution completed. Output:"
cat /home/ubuntu/sql_output.log

