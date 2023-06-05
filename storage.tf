resource "aws_efs_file_system" "efs1" {
  creation_token   = "efs1"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = "true"

  tags = {
    Name = "${var.env_code}efs"
  }
}

resource "aws_efs_mount_target" "efs-mt" {
  file_system_id  = aws_efs_file_system.efs1.id
  subnet_id       = module.vpc.public_subnets[0]
  security_groups = [aws_security_group.efs.id]
}


