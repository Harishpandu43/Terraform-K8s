data "aws_subnet_ids" "postgres" {
  vpc_id = aws_vpc.sigma-db-vpc.id
=======
  vpc_id = aws_vpc.sigma-vpc.id
}
resource "aws_db_subnet_group" "db-subnet-grp" {
  subnet_ids = aws_subnet_ids.postgres.ids
}

resource "aws_db_instance" "postgres" {
  allocated_storage       = 20
  storage_type            = "gp2"
  engine                  = "postgres"
  instance_class          = "db.t3.micro"
  identifier              = "sba"
  db_name                 = "smartbankapp"
  username                = "postgres"
  password                = "postgres"
  db_subnet_group_name    = aws_db_subnet_group.db-subnet-grp.name
  vpc_security_group_ids  = [aws_security_group.sigmadb-vpc-sg-db.id]
=======
  vpc_security_group_ids  = [aws_security_group.sigma-vpc-sg-db.id]
>>>>>>> c02095e6cf8f18a224b3e79b0e88ccc983f87350
  skip_final_snapshot     = "true"
}