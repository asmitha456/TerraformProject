#Nat Gateway
resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.web-public-Az1.id
  tags = {
    Name = "nat-gw"
  }
}

