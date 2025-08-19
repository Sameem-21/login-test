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
# S3 bucket creation


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
  set -e

  # Update and install Apache with SSL support
  apt update -y
  apt install -y apache2 openssl ssl-cert
  ${var.user_data}
  EOF

  tags = {
    Name = "${var.name_instance}-${count.index + var.name_offset+ 1}"
  }
}
  
  
