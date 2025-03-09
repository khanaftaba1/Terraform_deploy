
#################################################### prod Route Table peering 

# ✅ Route Table for Prod VPC
resource "aws_route_table" "prod_route_table" {
  vpc_id = aws_vpc.prod_vpc.id

  tags = {
    Name = "prod-route-table"
  }
}

resource "aws_route" "prod_to_non_prod" {
  route_table_id         = aws_route_table.prod_route_table.id
  destination_cidr_block = "10.1.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_prod_non_prod.id
}

# ✅ Associate Prod Private Subnets with Prod Route Table
resource "aws_route_table_association" "prod_private_subnet_1_assoc" {
  subnet_id      = aws_subnet.prod_private_subnet_1.id
  route_table_id = aws_route_table.prod_route_table.id
}

resource "aws_route_table_association" "prod_private_subnet_2_assoc" {
  subnet_id      = aws_subnet.prod_private_subnet_2.id
  route_table_id = aws_route_table.prod_route_table.id
}

#################################################### non_prod Route table peering + Igw

# Create a route table for Non-Prod Public Subnets (combined IGW + Peering)
resource "aws_route_table" "non_prod_public_route_table_combined" {
  vpc_id = aws_vpc.non_prod_vpc.id

  tags = {
    Name = "non-prod-public-route-table-combined"
  }
}

# Route to Internet Gateway for Public Subnets
resource "aws_route" "non_prod_public_to_igw" {
  route_table_id         = aws_route_table.non_prod_public_route_table_combined.id
  destination_cidr_block = "0.0.0.0/0"  # Route all traffic to the internet
  gateway_id             = aws_internet_gateway.non_prod_igw.id
}

# Route to Peering Connection for Communication between VPCs
resource "aws_route" "non_prod_to_prod_vpc" {
  route_table_id         = aws_route_table.non_prod_public_route_table_combined.id
  destination_cidr_block = "10.0.0.0/16"  # The CIDR block of the prod VPC
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_prod_non_prod.id
}

# Associate Non-Prod Public Subnet 1 with the Combined Route Table
resource "aws_route_table_association" "non_prod_public_subnet_1_assoc_combined" {
  subnet_id      = aws_subnet.non_prod_public_subnet_1.id
  route_table_id = aws_route_table.non_prod_public_route_table_combined.id
}

# Associate Non-Prod Public Subnet 2 with the Combined Route Table
resource "aws_route_table_association" "non_prod_public_subnet_2_assoc_combined" {
  subnet_id      = aws_subnet.non_prod_public_subnet_2.id
  route_table_id = aws_route_table.non_prod_public_route_table_combined.id
}

############################################## Nat Route Table and Association


resource "aws_route_table" "non_prod_private_route_table" {
  vpc_id = aws_vpc.non_prod_vpc.id

  tags = {
    Name = "non-prod-private-route-table"
  }
}

resource "aws_route" "non_prod_private_to_nat" {
  route_table_id         = aws_route_table.non_prod_private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
}

resource "aws_route_table_association" "non_prod_private_subnet_1_assoc" {
  subnet_id      = aws_subnet.non_prod_private_subnet_1.id
  route_table_id = aws_route_table.non_prod_private_route_table.id
}

resource "aws_route_table_association" "non_prod_private_subnet_2_assoc" {
  subnet_id      = aws_subnet.non_prod_private_subnet_2.id
  route_table_id = aws_route_table.non_prod_private_route_table.id
}
