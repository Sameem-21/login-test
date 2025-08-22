variable vpc_security_group_ids {
   description = "List of security group IDs to associate with the VPC"
   type        = list(string)
   default     = []
 }