#Create Internet Gateway
resource "aws_internet_gateway" "main-igw" {
  vpc_id = aws_vpc.vpc-main.id
  tags = {
    Name = "igw-main"
  }
}
