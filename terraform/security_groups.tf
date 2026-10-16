
resource "aws_security_group" "app" {
  name        = "aws-devops-app-sg"
  description = "Allow Flask app traffic from within the VPC"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow Flask traffic from within the VPC"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "aws-devops-app-sg"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
