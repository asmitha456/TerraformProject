resource "aws_instance" "app-instance"{
  image-id="ami-0ecb62995f68bb549"
  instance_type="t3.micro"
  security_groups=[aws_security_group.app-sg.id]
  subnet_group_ids=[aws_subnet_group.app-private-Az1.id]
  vpc_id=[aws_vpc.vpc-main]
  user_data=<<-EOF
            #!/bin/bash
            sudo apt update -y
            sudo apt install -y apache2
            sudo systemctl start apache2
            echo "<html><h1>Hello, I am implemented Highly Available 3-tier VPC architechture with ALB, Auto Scaling, and RDS Multi-AZ </html></h1> " > /var/www/html/index.html
            EOF
    tags={
        Name="App-Server"
  }
}

#Create image for App-tier
resource "aws_ami_from_instance" "myami" {
    name="my-custom-ami"
    source_instance_id=aws_instance.app-instance.id
    tags={
        Name="myami"
    }
}

#create target group and internal load balancer
resource "aws_lb" "alb" {
  name               = "app-alb"
  load_balancer_type = "application"
  security_group_ids    = [aws_security_group.internal-sg.id]
  subnet_ids           = [aws_subnet_id.app-private-Az1.id, aws_subnet_id.app-private-Az2.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "fixed-response"
    fixed-response{
      content_type="text/plain"
      message_body="404: page not found"
      status_code=404
    }
  }
}

resource "aws_lb_target_group" "alb-tg" {
  name     = "alb-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = [aws_vpc.vpc-main.id]
  health_check{
    path  ="/"
    protocol = "HTTP"
    matcher = "200"
    interval = "15"
    timeout  =  3
    healthy_threashold  =  2
    unhealthy_threashold  =  2
  }
}

resource "aws_lb_listener_rule" "alb-lsn" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100
  condition {
    path_pattern {
      values = ["*"]
    }
  }
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-tg.arn
  }
}

resource "aws_autoscaling_group" "app-asg"{
  instance=aws_instance.app-instance.name
  vpc_zone_identifiers=[aws_subnet_id.app-private-Az1.id, aws_subnet_id.app-private-Az2.id]
  vpc_id=[aws_vpc.vpc-main.id]
  
  min_size=2
  max_size=5

  tag{
    key="app-asg"
    value="appserver-with-asg"
    propagate_at_launch=true
  }
}
  
#Launch template
launch_template {
        id =aws_instance.app-server.id
        version = $Latest"
    }
tag_specifications {
    resource_type="instance"
    tags {
        key = "Name"
        value = "App-Server"
        propagate_at_launch = true
    }
}


