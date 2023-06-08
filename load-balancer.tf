module "lb" {
  source = "terraform-aws-modules/elb/aws"
  name   = "my-elb"




  subnets         = module.vpc.public_subnets
  security_groups = [aws_security_group.lb.id]
  internal        = false




  listener = [
    {
      instance_port     = 8080
      instance_protocol = "HTTP"
      lb_port           = 80
      lb_protocol       = "HTTP"
    },
    {
      instance_port      = 8080
      instance_protocol  = "HTTP"
      lb_port            = 443
      lb_protocol        = "HTTPS"
      ssl_certificate_id = module.acm.acm_certificate_arn
    },
  ]

  health_check = {
    target              = "TCP:8080"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5

  }

  number_of_instances = 1
  instances           = [aws_instance.jenkins.id]
  tags = {
    Name = "my-elb"
  }



}