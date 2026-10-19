
# Internet Gateway for the VPC
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "aws-devops-igw"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

# Route table for the public subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name        = "aws-devops-public-rt"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

# Associate the public subnet with its route table
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Route table for the private subnet
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "aws-devops-private-rt"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

# Associate the private subnet with its route table
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
