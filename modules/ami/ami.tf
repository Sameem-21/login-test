data "aws_ami" "ubuntu" {
   most_recent = true
   owners      = ["099720109477"]  # Canonical's official Ubuntu AMI owner ID

   filter {
     name   = "name" #default filter
     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
   }
 }