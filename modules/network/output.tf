output vpc_id {
 value = aws_vpc.Sam_auto_vpc.id
}
output subnet_id {
  value = aws_subnet.Sam_subnet_1.id
}
output routetableId {
  value = aws_route_table.Sam_route_table.id
}
output vpc_cidr_block {
  value = aws_vpc.Sam_auto_vpc.cidr_block
}