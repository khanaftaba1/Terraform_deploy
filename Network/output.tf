output "prod_vpc_id" {
  description = "The ID of the production VPC"
  value       = aws_vpc.prod_vpc.id
}

output "non_prod_vpc_id" {
  description = "The ID of the non-production VPC"
  value       = aws_vpc.non_prod_vpc.id
}

output "prod_private_subnets" {
  description = "IDs of production private subnets"
  value       = [aws_subnet.prod_private_subnet_1.id, aws_subnet.prod_private_subnet_2.id]
}

output "non_prod_public_subnets" {
  description = "IDs of non-production public subnets"
  value       = [aws_subnet.non_prod_public_subnet_1.id, aws_subnet.non_prod_public_subnet_2.id]
}

output "non_prod_private_subnets" {
  description = "IDs of non-production private subnets"
  value       = [aws_subnet.non_prod_private_subnet_1.id, aws_subnet.non_prod_private_subnet_2.id]
}

output "vpc_peering_connection_id" {
  description = "The ID of the VPC peering connection between production and non-production VPCs"
  value       = aws_vpc_peering_connection.peer_prod_non_prod.id
}