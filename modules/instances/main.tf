terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"
}
# rds creation

resource "aws_db_subnet_group" "Sam_private_subnet" {
  name       = "sam-private-subnet-group"
  subnet_ids = var.subnet_ids
  #vpc_id    = var.vpc_id

  tags = {
    Name = "Sam_private_subnet_group"  #it needs multible availibility zones so we are using the subnet_id variable which is a list of subnets.
  }
}

resource aws_db_instance "sam_db_instance" {
   identifier         = "sam-db-instance-new-2"
   allocated_storage  = 20
   engine             = "sqlserver-ex"
   engine_version     = "15.00"
   instance_class     = "db.t3.micro"
   username           = "admin"
   password           = "Passw0rd!23" # Change this to a secure password
   #db_name            = "samdb"
   skip_final_snapshot = true
   publicly_accessible = true
   storage_type       = "gp2"
   db_subnet_group_name = aws_db_subnet_group.Sam_private_subnet.name
   vpc_security_group_ids = var.security_group_id
   # Replace with your security group ID
 }

#adding the remote-exec block to execute commands after the instance is created.

# resource "null_resource" "backend_setup" {
#   count = var.instance_count
#   depends_on = [aws_instance.sam_instance]
#   connection {
#     type        = "ssh"
#     host        = aws_instance.sam_instance[count.index].public_ip
#     user        = "ubuntu"
#     private_key = file("C:/Users/10454/Downloads/sam-key-pair.pem")
#   }

#   provisioner "remote-exec" {
#     inline = [
#       # Install Node.js
#       "curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -",
#       "sudo apt-get install -y nodejs",

#       # Create app directory
#       "mkdir -p ~/app",

#       # Write backend script
#       "echo '${replace(file("${path.module}/server.js"), "'", "'\\''")}' > ~/app/server.js",


#       # Install dependencies
#       "cd ~/app && npm init -y && npm install express mssql body-parser",

#       # Start backend server
#       "nohup node ~/app/server.js > ~/app/server.log 2>&1 &"
#     ]
#   }
# }

resource "aws_instance" "sam_instance" {
count        = var.instance_count
  ami           = var.ami_id  # Replace with your AMI ID
  instance_type = var.instance_type # Replace with your instance type
  key_name      = var.key_name
  subnet_id     = var.subnet_id
  iam_instance_profile = var.iam_instance_profile
  security_groups = var.security_group_id
   associate_public_ip_address = true
   user_data = <<-EOF
#!/bin/bash
exec > /var/log/user_data.log 2>&1
set -e
set -x

# Update system
apt-get update -y

# Install Apache
apt-get install -y apache2
systemctl enable apache2
systemctl start apache2

# Deploy login page to Apache root
cat <<EOT > /var/www/html/index.html
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
      <label>Username:</label><input type="text" name="username"><br>
      <label>Password:</label><input type="password" name="password"><br>
      <input type="submit" value="Login">
    </form>
  </div>
</body>
</html>
EOT

# Install MSSQL tools only (not server)
/usr/bin/curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list | tee /etc/apt/sources.list.d/mssql-release.list
apt-get update -y
ACCEPT_EULA=Y apt-get install -y msodbcsql17 mssql-tools

# Add MSSQL tools to PATH
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> /etc/profile.d/mssql-tools.sh
source /etc/profile.d/mssql-tools.sh
EOF
connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("C:/Users/10454/Downloads/sam-key-pair.pem") # Replace with your actual key path
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 1080", # Give MSSQL time to boot if installed separately
      "/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P 'Passw0rd!23' -Q \"IF DB_ID('loginDB') IS NULL CREATE DATABASE SamDB\"",
      "/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P 'Passw0rd!23' -d loginDB -Q \"IF OBJECT_ID('user') IS NULL CREATE TABLE [user] (id INT IDENTITY(1,1) PRIMARY KEY, username NVARCHAR(100), password NVARCHAR(100))\""
    ]
  }



  tags = {
    Name = "${var.name_instance}-${count.index + var.name_offset+ 1}"
  }
}

  
  
