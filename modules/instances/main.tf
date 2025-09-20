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

resource "aws_db_subnet_group" "Sam_private_subnet_v2" {
  name_prefix = "db-subnet-group-"
  subnet_ids = var.subnet_ids
  #vpc_id    = var.vpc_id

  tags = {
    Name ="db-subnet-group"  #it needs multible availibility zones so we are using the subnet_id variable which is a list of subnets.
  }
   lifecycle {
    create_before_destroy = true
   }
}

resource aws_db_instance "sam_db_instance" {
   identifier         = "sam-db-instance-new-3"
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
   db_subnet_group_name = aws_db_subnet_group.Sam_private_subnet_v2.name
   vpc_security_group_ids = var.security_group_id
   # Replace with your security group ID
 }



resource "aws_instance" "sam_instance" {
count        = var.instance_count
  ami           = var.ami_id  # Replace with your AMI ID
  instance_type = var.instance_type # Replace with your instance type
  key_name      = var.key_name
  subnet_id     = var.subnet_id
  iam_instance_profile = var.iam_instance_profile
  security_groups = var.security_group_id
   associate_public_ip_address = true
   user_data = file("${path.module}/userdata.sh")
#   user_data = <<-EOF
# #!/bin/bash
# exec > /var/log/user_data.log 2>&1
# set -e
# set -x

# # Update system
# apt-get update -y

# # Install Nginx
# apt-get install -y nginx
# systemctl enable nginx
# systemctl start nginx

# # Deploy login page to Nginx root
# cat <<'HTML' > /usr/share/nginx/html/index.html
# <!DOCTYPE html>
# <html>
# <head>
# <title>Login</title>
# <style>
# body {
#   font-family: Arial, sans-serif;
#   background-color: #f4f4f4;
#   display: flex;
#   justify-content: center;
#   align-items: center;
#   height: 100vh;
# }
# .login-container {
#   background-color: #fff;
#   padding: 30px;
#   border-radius: 8px;
#   box-shadow: 0 0 10px rgba(0,0,0,0.1);
#   width: 300px;
# }
# h2 {
#   text-align: center;
#   margin-bottom: 20px;
# }
# input[type="text"],
# input[type="password"] {
#   width: 100%;
#   padding: 10px;
#   margin: 8px 0;
#   border: 1px solid #ccc;
#   border-radius: 4px;
#   box-sizing: border-box;
# }
# input[type="submit"] {
#   width: 100%;
#   padding: 10px;
#   background-color: #007bff;
#   color: white;
#   border: none;
#   border-radius: 4px;
#   cursor: pointer;
# }
# input[type="submit"]:hover {
#   background-color: #0056b3;
# }
# </style>
# </head>
# <body>
#   <div class="login-container">
#     <h2>Login Page</h2>
#     <form method="POST" action="/submit">
#       <label>Username:</label><input type="text" name="username" >
#       <label>Password:</label><input type="password" name="password" >
#       <input type="submit" value="Login">
#     </form>
#   </div>
# </body>
# </html>
# HTML

# # Install MSSQL tools
# curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
# curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list | tee /etc/apt/sources.list.d/mssql-release.list
# apt-get update -y
# ACCEPT_EULA=Y apt-get install -y msodbcsql17 mssql-tools

# # Add MSSQL tools to PATH
# echo "export PATH=\"\$PATH:/opt/mssql-tools/bin\"" >> /etc/profile.d/mssql-tools.sh
# source /etc/profile.d/mssql-tools.sh

# # Wait for RDS SQL Server to be ready
# until /opt/mssql-tools/bin/sqlcmd -S sam-db-instance-new-2.cz8eomwyg3n0.ap-south-1.rds.amazonaws.com,1433 -U admin -P "Passw0rd!23" -Q "SELECT name FROM sys.databases" > /dev/null 2>&1; do
#   echo "Waiting for RDS SQL Server to be ready..."
#   sleep 10
# done

# # Create DB and Users table
# cat <<'SQL' | /opt/mssql-tools/bin/sqlcmd -S sam-db-instance-new-2.cz8eomwyg3n0.ap-south-1.rds.amazonaws.com,1433 -U admin -P "Passw0rd!23"
# CREATE DATABASE SamDB;
# GO
# USE SamDB;
# GO
# CREATE TABLE Users (
#   ID INT PRIMARY KEY IDENTITY(1,1),
#   Username NVARCHAR(50),
#   Password NVARCHAR(100)
# );
# GO
# SQL
# EOF

     
   




  tags = {
    Name = "${var.name_instance}-${count.index + var.name_offset+ 1}"
  }
}

  
  
