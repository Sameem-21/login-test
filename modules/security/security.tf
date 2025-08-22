#security group creation
resource "aws_security_group" "sam_sec_group" {
  name        = "AllowHttp,Https Access"
  description = "Allow HTTP and HTTPS access"

  vpc_id = var.vpc_id  # Replace with your VPC ID
    lifecycle {
        create_before_destroy = true
    }
 tags = {
    Name = "AllowHttp,Https Access"
  }
}

#creation of ingress rules for the security group
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.sam_sec_group.id
  cidr_ipv4         = "0.0.0.0/0"
 
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.sam_sec_group.id
  cidr_ipv4         = "0.0.0.0/0"
 
    from_port   = 80
    to_port     = 80
    ip_protocol    = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_https_ipv4" {
  security_group_id = aws_security_group.sam_sec_group.id
  cidr_ipv4         = "0.0.0.0/0"
 
    from_port   = 443
    to_port     = 443
    ip_protocol    = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_nginx" {
  security_group_id = aws_security_group.sam_sec_group.id
  cidr_ipv4         = "0.0.0.0/0"
 
    from_port   = 3000
    to_port     = 3000
    ip_protocol    = "tcp"
}
#creating ingress rule for port 3389 for RDP access
resource "aws_vpc_security_group_ingress_rule" "allow_RDP_ipv4" {
  security_group_id = aws_security_group.sam_sec_group.id
  cidr_ipv4         = "0.0.0.0/0"
 
    from_port   = 3389
    to_port     = 3389
    ip_protocol    = "tcp"
}
#creating ingress rule for port 1433 for mssql access
resource "aws_vpc_security_group_ingress_rule" "allow_mssql_ipv4" {
  security_group_id = aws_security_group.sam_sec_group.id
  cidr_ipv4         = "0.0.0.0/0"
 
    from_port   = 1433
    to_port     = 1433
    ip_protocol    = "tcp"
}
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.sam_sec_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}