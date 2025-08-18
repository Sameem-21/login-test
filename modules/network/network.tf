#creating VPC network
resource "aws_vpc" "Sam_auto_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Sam_auto_vpc"
  }
}
#creating subnet

resource "aws_subnet" "Sam_subnet_1" {
  vpc_id            = aws_vpc.Sam_auto_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
    tags = {
        Name = "${var.name_prefix}_Sam_subnet_1"
    }
}
#creating internet gateway
resource "aws_internet_gateway" "Sam_igw" {
  vpc_id = aws_vpc.Sam_auto_vpc.id
  tags = {
    Name = "Sam_igw"
  }
}
#creating route table
resource "aws_route_table" "Sam_route_table" {
  vpc_id = aws_vpc.Sam_auto_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Sam_igw.id
  }
  tags = {
    Name = "Sam_route_table"
  } 
}

#associating route table with subnet
resource "aws_route_table_association" "Sam_route_table_association" {
  subnet_id      = aws_subnet.Sam_subnet_1.id
  route_table_id =  aws_route_table.Sam_route_table.id
}