resource "aws_iam_role" "main" {
  name                = var.env_code
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"]

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


resource "aws_iam_instance_profile" "my-inst-profile" {
  name = var.env_code
  role = aws_iam_role.main.name
}

resource "aws_security_group" "public" {
  name        = "${var.env_code}public"
  description = "Allow http"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow http traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]


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
resource "aws_instance" "public" {
  ami                         = "ami-0688ba7eeeeefe3cd" #"ami-06e85d4c3149db26a"
  instance_type               = "t2.micro"
  subnet_id                   = module.vpc.public_subnets[0]
  key_name                    = "main"
  vpc_security_group_ids      = [aws_security_group.public.id]
  associate_public_ip_address = true
  user_data                   = file("user-data.sh")

  iam_instance_profile = aws_iam_instance_profile.my-inst-profile.name
  tags = {
    name = "${var.env_code}public_instance"
  }
}
# resource "aws_instance" "production" {
#   ami                         = "ami-0688ba7eeeeefe3cd" #"ami-06e85d4c3149db26a"
#   instance_type               = "t2.micro"
#   subnet_id                   = module.vpc.public_subnets[0]
#   key_name                    = "main"
#   vpc_security_group_ids      = [aws_security_group.public.id]
#   associate_public_ip_address = true
  

#   iam_instance_profile = aws_iam_instance_profile.my-inst-profile.name
#   tags = {
#     name = "${var.env_code}public_instance"
#   }
# }
