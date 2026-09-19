
# local varibale which doesn't get change at runtime

# locals  {
#   name = var.env == "dev" ? "terra-auto-server" : "terra-auto-server-prod"
# }

# Key pair

resource "aws_key_pair" "deployer" {
  key_name   = "${var.env}-terra-auto-server-key" # dev-terra-auto-server-key
  public_key = file("././terra-auto-server-key.pub")
}

# AMI

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }


}

# VPC

resource "aws_default_vpc" "default" {

}

# Security grp

resource "aws_security_group" "my_ec2_sg" {
  name        = "${var.env}-terra-auto-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_default_vpc.default.id #interpolation

  tags = {
    Name = "allow_tls"
  }
}

# Ingress (Inbound Rule)

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.my_ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "TCP"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.my_ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "TCP"
  to_port           = 80
}

# Egress (Outbound Rules)

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.my_ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# Instance with all wiring

resource "aws_instance" "my_ec2_instance" {
  count                  = var.ec2_count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.my_ec2_sg.id]
  key_name               = aws_key_pair.deployer.key_name

  root_block_device {
    volume_size = var.ec2_volume_size
    volume_type = "gp3"
  }

  tags = {
    Name = "${var.env}-${var.ec2_instance_name}"
  }
}

# resource "aws_ec2_instance_state" "stop" {
#   instance_id = aws_instance.my_ec2_instance.id
#   state       = var.aws_ec2_instance_state
# }


