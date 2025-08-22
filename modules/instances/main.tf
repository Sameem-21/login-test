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
   identifier         = "sam-db-instance"
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


resource "aws_instance" "sam_instance" {
count        = var.instance_count
  ami           = var.ami_id  # Replace with your AMI ID
  instance_type = var.instance_type # Replace with your instance type
  key_name      = var.key_name
  subnet_id     = var.subnet_id
  iam_instance_profile = var.iam_instance_profile
  security_groups = var.security_group_id
   associate_public_ip_address = true
   user_data  = templatefile("${path.module}/scripts/user_data.sh", {
    login_page = var.login_page_html
    
  })

  tags = {
    Name = "${var.name_instance}-${count.index + var.name_offset+ 1}"
  }
}

  
  
