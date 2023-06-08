resource "aws_security_group" "public" {
  name        = "${var.env_code}public"
  description = "Allow http"
  vpc_id      = module.vpc.vpc_id
  dynamic "ingress" {
    for_each = var.ports_ec2
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.env_code}public_sg"
  }
}



resource "aws_security_group" "efs" {
  name   = "${var.env_code}efs"
  vpc_id = module.vpc.vpc_id
  ingress {

    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.public.id]


  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.public.id]
  }

  tags = {
    Name = "${var.env_code}efs"
  }
}

resource "aws_security_group" "lb" {
  name   = "${var.env_code}lb-sg"
  vpc_id = module.vpc.vpc_id
  dynamic "ingress" {
    for_each = var.elb_port
    content {

      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }


  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_code}efs"
  }
}


