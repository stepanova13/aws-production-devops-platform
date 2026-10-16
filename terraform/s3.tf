resource "aws_s3_bucket" "project" {
  bucket = "aws-production-devops-platform-dev"

  tags = {
    Name        = "aws-production-devops-platform"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}