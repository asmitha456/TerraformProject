#creating Public Subnets
resource "aws_subnet" "web-public-Az1" {
  vpc_id                  = aws_vpc.vpc-main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"
  tags = {
    Name = "web-public-AZ1"
  }
}
resource "aws_subnet" "web-public-Az2" {
  vpc_id                  = aws_vpc.vpc-main.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1b"
  tags = {
    Name = "web-public-AZ2"
  }
}

#creating Private Subnets
resource "aws_subnet" "app-private-Az1" {
  vpc_id                  = aws_vpc.vpc-main.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1a"
  tags = {
    Name = "app-private-Az1"
  }
}
resource "aws_subnet" "app-private-Az2" {
  vpc_id                  = aws_vpc.vpc-main.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1b"
  tags = {
    Name = "app-private-Az2"
  }
}
resource "aws_subnet" "db-private-Az1" {
  vpc_id                  = aws_vpc.vpc-main.id
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1a"
  tags = {
    Name = "db-private-Az1"
  }
}
resource "aws_subnet" "db-private-Az2" {
  vpc_id                  = aws_vpc.vpc-main.id
  cidr_block              = "10.0.6.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1b"
  tags = {
    Name = "db-private-Az2"
  }
}
