resource "aws_security_group" "harish-vpc-sg-db" {
  name = "harish-vpc-sg-db"
  description = "security group DB"
  vpc_id      = aws_vpc.harish-vpc.id
ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    description = "Allow traffic to DB"
    cidr_blocks = ["10.0.0.0/16"]
  }
ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    description = "Allow traffic to DB"
    cidr_blocks = ["10.0.0.0/16"]
  }
egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
tags = {
    Name = "harish-vpc-sg-db"
  }
}