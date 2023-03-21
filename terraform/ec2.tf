# Ubuntu Server 22.04 LTS (HVM),EBS General Purpose (SSD) Volume 
module "ec2" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "~> 2.0"

  name                        = "appserver"
  ami                         = "ami-00874d747dde814fa"
  instance_type               = "t2.micro"
  key_name                    = "ec2-dev"
  associate_public_ip_address = true
  subnet_ids                  = [aws_subnet.EC2-sub.id]
  vpc_security_group_ids      = [aws_security_group.bm-sec-group.id]

    tags = {
    Name = "bookmark"
  }
}
