output "public_ips" {
  value       = [for inst in aws_instance.sam_instance : inst.public_ip]
  description = "List of public IPs for all EC2 instances"
}

output "subnet_ids" {
  value       = [for inst in aws_instance.sam_instance : inst.subnet_id]
  description = "List of subnet IDs for all EC2 instances"
}

output "instance_names" {
  value       = [for inst in aws_instance.sam_instance : inst.tags["Name"]]
  description = "List of Name tags for all EC2 instances"
}
#output "private_subnet_ids" {
#   value       = aws_db_subnet_group.Sam_private_subnet.subnet_ids #just a string so no loop needed.
#   description = "List of private subnet IDs"
# }
