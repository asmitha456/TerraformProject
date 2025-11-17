#create sg for external load balancer
resource "aws_security_group" external-lb-sg"{
  vpc_id=aws_vpc.vpc-main.id
  name="external-lb-sg"
  description="security group allows http, all traffic"
  egress{
    from_port=0
    to_port=0
    protocol="-1"
    cidr_blocks=["0.0.0.0/0"]
  }

  ingress{
    from_port=80
    to_port=80
    protocol="tcp"
    cidr_blocks=["0.0.0.0/0"]
  }
  tags={
    Name="external-lb-sg"
  }
}

#create sg for web-tier
resource "aws_security_group" web-sg"{
  vpc_id=aws_vpc.vpc-main.id
  name="web-sg"
  vpc_security_group_ids=[aws_security_group.external-lb-sg]
  description="security group allows http, all traffic, external sg"
  egress{
    from_port=0
    to_port=0
    protocol="-1"
    cidr_blocks=["0.0.0.0/0"]
  }

  ingress{
    from_port=80
    to_port=80
    protocol="tcp"
    cidr_blocks=["0.0.0.0/0"]
  }
  tags={
    Name="web-sg"
  }
}

#create sg for internal loab balancer
resource "aws_security_group" internal-lb-sg"{
  vpc_id=aws_vpc.vpc-main.id
  name="internal-lb-sg"
  vpc_security_group_ids=[aws_security_group.web-sg]
  description="security group allows http and web-sg"
  
  ingress{
    from_port=80
    to_port=80
    protocol="tcp"
    cidr_blocks=["0.0.0.0/0"]
  }
  tags={
    Name="internal-lb-sg"
  }
}

#create sg for app-tier
resource "aws_security_group" app-sg"{
  vpc_id=aws_vpc.vpc-main.id
  name="app-sg"
  vpc_security_group_ids=[aws_security_group.internal-lb-sg]
  description="security group allows custom, all traffic, internal lb sg"
  egress{
    from_port=4000
    to_port=4000
    protocol="-1"
    cidr_blocks=["0.0.0.0/0"]
  }
  ingress{
    from_port=4000
    to_port=4000
    protocol="tcp"
    cidr_blocks=["0.0.0.0/0"]
  }
  tags={
    Name="app-sg"
  }
}

#create sg for RDS Database
resource "aws_security_group" db-sg"{
  vpc_id=aws_vpc.vpc-main.id
  name="db-sg"
  vpc_security_group_ids=[aws_security_group.app-sg]
  description="security group allows mysql and app sg"
  
  ingress{
    from_port=3306
    to_port=3306
    protocol="tcp"
    cidr_blocks=["0.0.0.0/0"]
  }
  tags={
    Name="db-sg"
  }
}
