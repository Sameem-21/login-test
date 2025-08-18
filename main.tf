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
#configuring the network module 

module "network" {
  source      = "./modules/network"
  name_prefix = "sam-subnet"

}

module "security" {
  source = "./modules/security"
  vpc_id = module.network.vpc_id #module.network.<output_name>

}
# module "key" {
#   source = "./modules/key"

# }
module "ami" {
  source = "./modules/ami"
}

module "instances" {
  source            = "./modules/instances"
  ami_id            = module.ami.ami_id
  instance_type     = "t3.micro"                      # Replace with your desired instance type
  key_name          = "sam-key-pair"                  # Replace with your key pair name
  security_group_id = [module.security.sam_sec_group] # Replace with your security group ID
  instance_count    = 1
  subnet_id         = module.network.subnet_id # Replace with your subnet ID
  name_offset       = 1
  name_instance =  "sam_web_application"
  #installing Apache and writing this sample html login page in /var/www/html folder#
  user_data = <<-EOF
  #!/bin/bash
  # Update package list
  apt update -y

  

  # Create login page
  cat <<EOT > /var/www/html/index.html
  <!DOCTYPE html>
  <html lang="en">
  <head>
    <meta charset="UTF-8">
    <title>Test-Sam-EC2 Login</title>
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
      <h2>Login to EC2</h2>
      <form action="/login" method="POST">
        <label for="username">Username</label>
        <input type="text" id="username" name="username" required>

        <label for="password">Password</label>
        <input type="password" id="password" name="password" required>

        <input type="submit" value="Login">
      </form>
    </div>
  </body>
  </html>
  EOT

  # Restart Apache to apply changes
  systemctl restart apache2
EOF
}
# modified files
# module "instances2" {
#   source            = "./modules/instances"
#   ami_id            = "ami-05b85154f69f6bcb3"
#   instance_type     = "t3.micro"                      # Replace with your desired instance type
#   key_name          = "sam-key-pair"                  # Replace with your key pair name
#   security_group_id = [module.security.sam_sec_group] # Replace with your security group ID
#   instance_count    = 1
#   subnet_id         = module.network.subnet_id # Replace with your subnet ID
#   name_offset       = 1                        # Offset for naming instances
#   user_data= <<-EOF
#     <powershell>
#     Invoke-WebRequest -Uri "https://nginx.org/download/nginx-1.24.0.zip" -OutFile "C:\\nginx.zip"
#     Expand-Archive -Path "C:\\nginx.zip" -DestinationPath "C:\\nginx"
#     Start-Process "C:\\nginx\\nginx-1.24.0\\nginx.exe"
#     </powershell>
#   EOF
# }


