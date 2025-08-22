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
module "s3bucket" {
  source = "./modules/s3bucket"
  
} 

module "instances" {
  source            = "./modules/instances"
  ami_id            = module.ami.ami_id
  instance_type     = "t3.micro"                      # Replace with your desired instance type
  key_name          = "sam-key-pair"                  # Replace with your key pair name
  security_group_id = [module.security.sam_sec_group] # Replace with your security group ID
  instance_count    = 1
  iam_instance_profile = module.s3bucket.Sam_ec2_instance_profile # instance profile created above
  subnet_id         = module.network.subnet_id# Replace with your subnet ID
  name_offset       = 0
  #vpc_id= module.network.vpc_id # VPC ID from the network module
  subnet_ids = module.network.private_subnet_ids # Subnet IDs for DB subnet group
  name_instance =  "sam_web_application_fullstack"
  login_page_html   = file("${path.module}/templates/index.html")


 

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


