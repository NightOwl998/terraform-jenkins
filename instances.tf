data "aws_secretsmanager_secret" "db_psswd" {
  name = "rds/password"
}
data "aws_secretsmanager_secret_version" "db_psswd" {
  secret_id = data.aws_secretsmanager_secret.db_psswd.id

}
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

resource "aws_instance" "jenkins" {
  depends_on                  = [aws_efs_mount_target.efs-mt]
  ami                         = "ami-0688ba7eeeeefe3cd" #"ami-06e85d4c3149db26a"
  instance_type               = "t2.micro"
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.public.id]
  associate_public_ip_address = true
  user_data                   = base64encode(templatefile("user-data.tpl", { aws_efs_id = aws_efs_file_system.efs1.id }))

  iam_instance_profile = aws_iam_instance_profile.my-inst-profile.name
  tags = {
    name = "jenkins"
  }
}
resource "aws_instance" "agent1" {
  ami                         = "ami-0688ba7eeeeefe3cd" #"ami-06e85d4c3149db26a"
  instance_type               = "t2.micro"
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.public.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.my-inst-profile.name
  user_data                   = base64encode(templatefile("user-data2.tpl", { password = jsondecode(data.aws_secretsmanager_secret_version.db_psswd.secret_string)["password"] }))

  tags = {
    name = "production"
  }
}

