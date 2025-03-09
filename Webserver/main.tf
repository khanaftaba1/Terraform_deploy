provider "aws" {
  region = "us-east-1"
}

####################################### S3 bucket network tf.state retrieval

data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    bucket = "env-aftabsbigbukcet"
    key    = "networking/terraform.tfstate"
    region = "us-east-1"
  }
}

######################################### Key pair
resource "aws_key_pair" "asg_key" {
  key_name   = "asg-key"
  public_key = file("./my_key.pub")
}

############################################################### PROD Webserver

resource "aws_instance" "prod_vm_1" {
  ami             = "ami-08b5b3a93ed654d19"
  instance_type   = "t2.micro"
  subnet_id       = data.terraform_remote_state.networking.outputs.prod_private_subnets[0]
  vpc_security_group_ids = [aws_security_group.prod_sg.id]
  key_name        = aws_key_pair.asg_key.key_name

  tags = {
    Name = "prod-vm-1"
  }
}

resource "aws_instance" "prod_vm_2" {
  ami             = "ami-08b5b3a93ed654d19"
  instance_type   = "t2.micro"
  subnet_id       = data.terraform_remote_state.networking.outputs.prod_private_subnets[1]
  vpc_security_group_ids = [aws_security_group.prod_sg.id]
  key_name        = aws_key_pair.asg_key.key_name

  tags = {
    Name = "prod-vm-2"
  }
}

############################################################### nonProd Bastion Host

resource "aws_instance" "bastion_host" {
  ami             = "ami-08b5b3a93ed654d19"
  instance_type   = "t2.micro"
  subnet_id       = data.terraform_remote_state.networking.outputs.non_prod_public_subnets[1]
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  key_name        = aws_key_pair.asg_key.key_name

  tags = {
    Name = "non-prod-bastion-host"
  }
}

############################################################### nonProd Webserver

resource "aws_instance" "non_prod_vm_1" {
  ami             = "ami-08b5b3a93ed654d19"
  instance_type   = "t2.micro"
  subnet_id       = data.terraform_remote_state.networking.outputs.non_prod_private_subnets[0]
  vpc_security_group_ids = [aws_security_group.non_prod_sg_ec2.id]
  key_name        = aws_key_pair.asg_key.key_name
  user_data       = file("./user_data.sh")

  tags = {
    Name = "non_prod-vm-1"
  }
}

resource "aws_instance" "non_prod_vm_2" {
  ami             = "ami-08b5b3a93ed654d19"
  instance_type   = "t2.micro"
  subnet_id       = data.terraform_remote_state.networking.outputs.non_prod_private_subnets[1]
  vpc_security_group_ids = [aws_security_group.non_prod_sg_ec2.id]
  key_name        = aws_key_pair.asg_key.key_name
  user_data       = file("./user_data.sh")

  tags = {
    Name = "non_prod-vm-2"
  }
}

########################################################### ALB

resource "aws_lb" "non_prod_alb" {
  name               = "non-prod-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.non_prod_sg.id]
  subnets = [
    data.terraform_remote_state.networking.outputs.non_prod_public_subnets[0],
    data.terraform_remote_state.networking.outputs.non_prod_public_subnets[1]
  ]
  enable_deletion_protection = false
  idle_timeout = 60

  tags = {
    Name = "non-prod-alb"
  }
}

resource "aws_lb_target_group" "non_prod_target_group" {
  name        = "non-prod-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.terraform_remote_state.networking.outputs.non_prod_vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name = "non-prod-target-group"
  }
}

resource "aws_lb_listener" "non_prod_alb_listener" {
  load_balancer_arn = aws_lb.non_prod_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.non_prod_target_group.arn
  }
}

resource "aws_lb_target_group_attachment" "non_prod_vm_1_attachment" {
  target_group_arn = aws_lb_target_group.non_prod_target_group.arn
  target_id        = aws_instance.non_prod_vm_1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "non_prod_vm_2_attachment" {
  target_group_arn = aws_lb_target_group.non_prod_target_group.arn
  target_id        = aws_instance.non_prod_vm_2.id
  port             = 80
}
