resource "aws_instance" "app" {
  ami                         = "ami-0d6e34c14757a048b"
  instance_type               = "t3.micro"
  iam_instance_profile        = aws_iam_instance_profile.ec2_ssm.name
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.app.id]
  associate_public_ip_address = true

  tags = {
    Name        = "aws-production-devops-app"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

