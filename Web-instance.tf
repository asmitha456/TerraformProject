resource "aws_instance" "web-instance"{
  image-id="ami-0ecb62995f68bb549"
  instance_type="t3.micro"
  security_groups=[aws_security_group.web-sg.id]
  subnet_group_ids=[aws_subnet_group.web-public-Az1.id]
  vpc_id=[aws_vpc.vpc-main]
  user_data=<<-EOF
            #!/bin/bash
            sudo apt update -y
            sudo apt install -y apache2
            sudo systemctl start apache2
            echo "<html><h1>Hello, I am implemented Highly Available 3-tier VPC architechture with ALB, Auto Scaling, and RDS Multi-AZ </html></h1> " > /var/www/html/index.html
            EOF
  lifecycle{
    create_before_destroy=true
  }
}