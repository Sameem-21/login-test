#!/bin/bash
set -e
exec > /var/log/sql_install.log 2>&1

echo "🔧 Installing MSSQL tools..."

curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list | sudo tee /etc/apt/sources.list.d/mssql-release.list

sudo apt-get update
ACCEPT_EULA=Y sudo apt-get install -y msodbcsql17 mssql-tools

# Add to system-wide PATH
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' | sudo tee /etc/profile.d/mssql-tools.sh
chmod +x /etc/profile.d/mssql-tools.sh

echo "✅ MSSQL tools installed and PATH configured."
