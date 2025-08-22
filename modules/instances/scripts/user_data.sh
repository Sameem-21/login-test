#!/bin/bash
set -e
exec > /var/log/user_data.log 2>&1
export DEBIAN_FRONTEND=noninteractive

# Wait for network
until curl -s https://packages.microsoft.com/keys/microsoft.asc; do
  echo "Waiting for network..."
  sleep 5
done

# Install Apache
apt update -y
apt install -y apache2

# Inject login page
cat <<EOT > /var/www/html/index.html
${login_page}
EOT
systemctl restart apache2

# Install MSSQL tools
curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list | tee /etc/apt/sources.list.d/mssql-release.list
apt-get update
ACCEPT_EULA=Y apt-get install -y msodbcsql17 mssql-tools
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> /home/ubuntu/.bashrc
source /home/ubuntu/.bashrc

#######node js plus sql server installation



set -e
exec > /var/log/user_data.log 2>&1
export DEBIAN_FRONTEND=noninteractive

# Wait for network
until curl -s https://packages.microsoft.com/keys/microsoft.asc; do
  echo "Waiting for network..."
  sleep 5
done

# Install Apache
apt update -y
apt install -y apache2

# Inject login page directly (replace with actual HTML if needed)
cat <<EOT > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head><title>Login</title></head>
<body>
  <form method="POST" action="/login">
    <input type="text" name="username" placeholder="Username" required />
    <input type="password" name="password" placeholder="Password" required />
    <button type="submit">Login</button>
  </form>
</body>
</html>
EOT

# Stop Apache to avoid port conflict
systemctl stop apache2

# Install MSSQL tools
curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list | tee /etc/apt/sources.list.d/mssql-release.list
apt-get update
ACCEPT_EULA=Y apt-get install -y msodbcsql17 mssql-tools

# Add sqlcmd to PATH for root
export PATH="$PATH:/opt/mssql-tools/bin"

# Install Node.js
apt install -y nodejs npm

# Create backend folder
mkdir -p /home/ubuntu/login-app
cd /home/ubuntu/login-app
npm init -y
npm install express body-parser mssql

# Create server.js
cat <<EOF > /home/ubuntu/login-app/server.js
const express = require('express');
const bodyParser = require('body-parser');
const sql = require('mssql');
const path = require('path');

const app = express();
app.use(bodyParser.urlencoded({ extended: true }));

const config = {
  user: 'admin',
  password: 'Passw0rd!23',
  server: 'sam-db-instance.cz8eomwyg3n0.ap-south-1.rds.amazonaws.com',
  port: 1433,
  database: 'sam',
  options: {
    encrypt: true,
    trustServerCertificate: true
  }
};

app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'index.html'));
});

app.post('/login', async (req, res) => {
  const { username, password } = req.body;

  try {
    await sql.connect(config);
    await sql.query\`INSERT INTO Users (Username, Password) VALUES ('\${username}', '\${password}')\`;
    res.send('Login data stored successfully!');
  } catch (err) {
    console.error(err);
    res.status(500).send('Database error');
  }
});

app.listen(80, () => {
  console.log('Server running on port 80');
});
EOF

# Move login page to backend folder
mv /var/www/html/index.html /home/ubuntu/login-app/index.html

# Start Node.js app
node /home/ubuntu/login-app/server.js &


