resource "aws_subnet" "Sam_private_subnet" {
  vpc_id            = aws_vpc.Sam_auto_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "Sam_private_subnet"
  }
}

resource aws_db_instance "sam_db_instance" {
   identifier         = "sam-db-instance-1-new"
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
   db_subnet_group_name = aws_subnet.Sam_private_subnet.id
   vpc_security_group_ids = var.vpc_security_group_ids
   # Replace with your security group ID
 }