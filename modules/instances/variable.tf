variable security_group_id {
   description = "The ID of the security group"
   type        = list(string)
   default     = []
 }
 variable key_name{
   description = "The name of the key pair"
   type        = string
   default     = ""
 }
 variable ami_id {
   description = "The AMI ID to use for the instance"
   type        = string
   default     = ""
 }
 variable instance_type {
   description = "The type of instance to create"
   type        = string
   default     = "t3.micro"
 }
 variable instance_count {
   description = "The number of instances to create"
   type        = number
   default     = 1
 }
 variable name_offset {
   description = "Offset for naming instances"
   type        = number
   default     = 0
 }
 variable subnet_id {
    description = "The ID of the subnet where the instance will be launched"
    type        = string
    default     = ""
 }
 variable user_data {
   description = "User data script to run on instance launch"
   type        = string
 }
 variable name_instance {
   description = "Base name for the instance"
   type        = string
   #default     = "sam-instance"
 }
 variable aws_iam_instance_profile {
   description = "The IAM instance profile to associate with the instance"
   type        = string
 }