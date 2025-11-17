#create Rds subnet group
resource "aws_db_subnet_group" "rds_subnet_group" {
    name = "rds-subnet-group"
    subnet_ids = [aws_subnet.db_private_Az1.id, aws_subnet.db_private_Az2.id]

    tags = {
        Name = "rds-subnet-group"
    }
}

resource "aws_db_instance" "mydb"{
  allocated_storage=100
  engine="mysql"
  engine_version="8.0"
  instance_class="db.t3.micro"
  name="mydb"
  username="admin"
  password="admin"
  skip_final_snapshot=true
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  multi-az = true
  publicly_accessible = true
    tags = {
        Name = "my-rds-instance"
    }
}