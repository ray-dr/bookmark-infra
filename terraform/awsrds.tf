
# read rds secrets from secrets manager
data "aws_secretsmanager_secret" "rds_access" {
  name = "RDS"
}
data "aws_secretsmanager_secret_version" "rds_access" {
  secret_id = data.aws_secretsmanager_secret.rds_access.id
}
locals {
  rds = data.aws_secretsmanager_secret_version.rds_access.secret_string
}
data "aws_secretsmanager_secret" "rds" {
  arn = "arn:aws:secretsmanager:us-east-1:242203076144:secret:RDS-hTUqO1"
}
data "aws_secretsmanager_secret_version" "rds" {
  secret_id = data.aws_secretsmanager_secret.rds.id
}
locals {
  rds_access = jsondecode(data.aws_secretsmanager_secret_version.rds.secret_string)
}
resource "aws_db_instance" "bookmarkrds" {
  identifier = "db-dev"
  allocated_storage = 10
  engine = "mysql"
  engine_version = "5.7"
  instance_class = "db.t2.micro"
  username = local.rds_access.username
  password = local.rds_access.password
  db_subnet_group_name   = aws_db_subnet_group.rds-subnet-group.name
  vpc_security_group_ids = [aws_security_group.bm-sec-group.id]
  parameter_group_name   = aws_db_parameter_group.bm-parameter.name
  publicly_accessible    = true
  skip_final_snapshot    = true
  final_snapshot_identifier = "db-dev-${formatdate("YYYYMMDDhhmmss", timestamp())}" 

    tags = {
    Name = "bookmark"
  }

}
