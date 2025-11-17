#Create Routing Table for Web Server
resource "aws_route_table" "public-route"{
  vpc_id=aws_vpc.vpc-main.id
  route{
    cidr_block="0.0.0.0/0"
    gateway_id=aws_internet_gateway.main-igw.id
  }
  tags={
    Name="public-route"
  }
}

#Route Associated Public Subnets
resorce "aws_route_table_association" "public-route-subnet1"{
  subnet_id=aws_subnet.vpc-main-web-public-Az1.id
  route_table_id=aws_route_table.public-route.id
}
resorce "aws_route_table_association" "public-route-subnet2"{
  subnet_id=aws_subnet.vpc-main-web-public-Az2.id
  route_table_id=aws_route_table.public-route.id
}

#Create route table for App and DB server
resource "aws_route_table" "private-route"{
  vpc_id=aws_vpc-main.id
  route{
    cidr_block="0.0.0.0/0"
    nat_gateway_id=aws_nat_gateway.nat-gw.id
}
  tags={
    Name="private-route"
  } 
}

#Route associations private subnets
resource "aws_route_table_association" "private-route-subnet3"{
  subnet_id=aws_subnet.vpc-main-app-private-Az1.id
  route_table_id=aws_route_table.private-route.id
}
resource "aws_route_table_association" "private-route-subnet4"{
  subnet_id=aws_subnet.vpc-main-app-private-Az2.id
  route_table_id=aws_route_table.private-route.id
}
resource "aws_route_table_association" "private-route-subnet5"{
  subnet_id=aws_subnet.vpc-main-db-private-Az1.id
  route_table_id=aws_route_table.private-route.id
}
resource "aws_route_table_association" "private-route-subnet6"{
  subnet_id=aws_subnet.vpc-main-db-private-Az2.id
  route_table_id=aws_route_table.private-route.id
}