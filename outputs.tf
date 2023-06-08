output "jenkins_cp_public_ip" {
  value = aws_instance.jenkins.public_ip
}
output "jenkins_cp_private_ip" {
  value = aws_instance.jenkins.private_ip
}

output "agent1_public_ip" {
  value = aws_instance.agent1.public_ip
}

output "agent1_private_ip" {
  value = aws_instance.agent1.private_ip
}
output "elb" {
  value = module.lb.elb_dns_name
}

