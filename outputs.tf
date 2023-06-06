output "public_ip" {
  value = aws_instance.jenkins.public_ip
}
output "production_ip" {
  value = aws_instance.production.public_ip
}
output "elb" {
  value = module.lb.elb_dns_name
}

