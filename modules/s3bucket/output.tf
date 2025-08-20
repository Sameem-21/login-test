output "Sam_ec2_role"{
  value = aws_iam_role.sam_ec2_role_1.name
}

output "Sam_ec2_instance_profile"{
  value = aws_iam_instance_profile.sam_ec2_instance_profile.name
}   

output "Sam_bucket_name" {
  value = aws_s3_bucket.sam_bucket.bucket
}

output "sam_policy_attached_to_iamRole" {
  value = aws_iam_role_policy_attachment.sam_ec2_policy_attachment.policy_arn
}