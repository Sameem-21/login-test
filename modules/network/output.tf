output vpc_id {
 value = aws_vpc.Sam_auto_vpc.id
}
output private_subnet_ids {
  value = [aws_subnet.Sam_subnet_1.id,
   aws_subnet.Sam_subnet_2.id]
  description = "List of private subnet IDs"
}

output subnet_id {
  value = aws_subnet.Sam_subnet_1.id
  description = "The ID of the first subnet"
}
output routetableId {
  value = aws_route_table.Sam_route_table.id
}
output vpc_cidr_block {
  value = aws_vpc.Sam_auto_vpc.cidr_block
}