############################### Security Groups

# Security Group for Non-Production VPC
resource "aws_security_group" "bastion_sg" {
  vpc_id = data.terraform_remote_state.networking.outputs.non_prod_vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["44.196.56.217/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion_sg"
  }
}


# Security Group for Production VPC
resource "aws_security_group" "prod_sg" {
  vpc_id = data.terraform_remote_state.networking.outputs.prod_vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "prod-sg"
  }
}

# Security Group for Non-Production EC2 Instances
resource "aws_security_group" "non_prod_sg_ec2" {
  vpc_id = data.terraform_remote_state.networking.outputs.non_prod_vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.non_prod_sg.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "non-prod-sg-ec2"
  }
}

# Security Group for Non-Production VPC
resource "aws_security_group" "non_prod_sg" {
  vpc_id = data.terraform_remote_state.networking.outputs.non_prod_vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "non-prod-sg"
  }
}


