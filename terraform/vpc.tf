module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.77.0"

  name                 = "bm-vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = ["us-east-1a", "us-east-1b", "us-east-1c"]
  
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "bookmark"
  }
}

resource "aws_subnet" "EC2-sub" {
    vpc_id = module.vpc.vpc_id
    availability_zone = "us-east-1a"
    cidr_block  = "10.0.101.0/24"
    tags = {
    Name = "bookmark"
  }
}
resource "aws_subnet" "RDS-sub1" {
    vpc_id = module.vpc.vpc_id
    availability_zone = "us-east-1b"
    cidr_block  = "10.0.1.0/24"

    tags = {
    Name = "bookmark"
  }
}
resource "aws_subnet" "RDS-sub2" {
    vpc_id = module.vpc.vpc_id
    availability_zone = "us-east-1c"
    cidr_block  = "10.0.2.0/24"

    tags = {
    Name = "bookmark"
  }
}
resource "aws_db_subnet_group" "rds-subnet-group" {
  name = "bm-rds-subnetgroup"
  subnet_ids = [aws_subnet.RDS-sub1.id, aws_subnet.RDS-sub2.id]
  tags = {
    Name = "bookmark"
  }
}

resource "aws_route_table" "bm-rt" {
  vpc_id = module.vpc.vpc_id
  tags = {
    Name = "bookmark"
  }
}

resource "aws_route_table_association" "EC2-sub-a" {
  subnet_id = aws_subnet.EC2-sub.id
  route_table_id = aws_route_table.bm-rt.id
}

resource "aws_route_table_association" "RDS-sub1-a" {
  subnet_id = aws_subnet.RDS-sub1.id
  route_table_id = aws_route_table.bm-rt.id
}
resource "aws_route_table_association" "RDS-sub2-a" {
  subnet_id = aws_subnet.RDS-sub2.id
  route_table_id = aws_route_table.bm-rt.id
}
resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = module.vpc.vpc_id
}

resource "aws_route" "internet-route" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id = aws_route_table.bm-rt.id
  gateway_id = aws_internet_gateway.internet-gateway.id

}
resource "aws_security_group" "bm-sec-group" {
  name   = "bm-sec-group"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "bookmark"
  }
}

resource "aws_db_parameter_group" "bm-parameter" {
  name   = "bm-parameter"
  family = "mysql5.7"

  tags = {
    Name = "bookmark"
  }
}
