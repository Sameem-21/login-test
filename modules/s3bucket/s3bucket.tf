#creating IAM role for EC2 instance
resource "aws_iam_role" "sam_ec2_role_2" {
  name = "sam_ec2_role_2"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

#attaching policy to IAM role
resource "aws_iam_role_policy_attachment" "sam_ec2_policy_attachment" {
  role       = aws_iam_role.sam_ec2_role_2.name #role we created above 
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

#creating IAM instance profile
resource "aws_iam_instance_profile" "sam_ec2_instance_profile_1" {
  name = "sam_ec2_instance_profile_1"
  role = aws_iam_role.sam_ec2_role_2.name
}