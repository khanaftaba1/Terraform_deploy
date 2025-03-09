provider "aws" {
  region = "us-east-1"
}

#################################################### VPC

# ✅ Production VPC
resource "aws_vpc" "prod_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "prod-vpc"
  }
}

# ✅ Non-Production VPC
resource "aws_vpc" "non_prod_vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "non-prod-vpc"
  }
}

#################################################### Subnets

# ✅ Production Private Subnets
resource "aws_subnet" "prod_private_subnet_1" {
  vpc_id            = aws_vpc.prod_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "prod-private-subnet-1"
  }
}

resource "aws_subnet" "prod_private_subnet_2" {
  vpc_id            = aws_vpc.prod_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "prod-private-subnet-2"
  }
}

# ✅ Non-Production Public Subnets
resource "aws_subnet" "non_prod_public_subnet_1" {
  vpc_id                  = aws_vpc.non_prod_vpc.id
  cidr_block              = "10.1.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "non-prod-public-subnet-1"
  }
}

resource "aws_subnet" "non_prod_public_subnet_2" {
  vpc_id                  = aws_vpc.non_prod_vpc.id
  cidr_block              = "10.1.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "non-prod-public-subnet-2"
  }
}

# ✅ Non-Production Private Subnets
resource "aws_subnet" "non_prod_private_subnet_1" {
  vpc_id            = aws_vpc.non_prod_vpc.id
  cidr_block        = "10.1.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "non-prod-private-subnet-1"
  }
}

resource "aws_subnet" "non_prod_private_subnet_2" {
  vpc_id            = aws_vpc.non_prod_vpc.id
  cidr_block        = "10.1.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "non-prod-private-subnet-2"
  }
}

#################################################### Igw

# ✅ Internet Gateway for Non-Prod Public Subnets
resource "aws_internet_gateway" "non_prod_igw" {
  vpc_id = aws_vpc.non_prod_vpc.id

  tags = {
    Name = "non-prod-igw"
  }
}

############################################## Nat Gateway
resource "aws_eip" "nat_eip" {
  vpc = true

  tags = {
    Name = "nat-gateway-eip"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.non_prod_public_subnet_1.id

  tags = {
    Name = "non-prod-nat-gateway"
  }
}

#################################################### Peering

# ✅ VPC Peering Connection
resource "aws_vpc_peering_connection" "peer_prod_non_prod" {
  vpc_id      = aws_vpc.prod_vpc.id
  peer_vpc_id = aws_vpc.non_prod_vpc.id
  auto_accept = true

  tags = {
    Name = "prod-non-prod-peer"
  }
}
