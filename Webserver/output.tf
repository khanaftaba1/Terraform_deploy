output "alb_dns_name" {
  value = aws_lb.non_prod_alb.dns_name
}

output "bastion_public_ip" {
  value = aws_instance.bastion_host.public_ip
}