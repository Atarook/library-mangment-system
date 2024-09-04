
# Create a VPC
resource "aws_vpc" "Team4" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Team4-vpc"
  }
}

# Create a public subnet
resource "aws_subnet" "team4_public_subnet_1a" {
  vpc_id                  = aws_vpc.Team4.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "team4-public-subnet-1a"
  }
}

resource "aws_subnet" "team4_public_subnet_1b" {
  vpc_id                  = aws_vpc.Team4.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-west-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "team4-public-subnet-1b"
  }
}

# Create a private subnet
resource "aws_subnet" "team4_private_subnet_1a" {
  vpc_id            = aws_vpc.Team4.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "eu-west-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "team4-private-subnet-1a"
  }
}

resource "aws_subnet" "team4_private_subnet_1b" {
  vpc_id            = aws_vpc.Team4.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "eu-west-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "team4-private-subnet-1b"
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "Team4" {
  vpc_id = aws_vpc.Team4.id

  tags = {
    Name = "team4-gateway"
  }
}

# Create a route table for the public subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.Team4.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Team4.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# Associate the route table with the first public subnet
resource "aws_route_table_association" "public_subnet_1a" {
  subnet_id      = aws_subnet.team4_public_subnet_1a.id
  route_table_id = aws_route_table.public.id
}

# Associate the route table with the second public subnet
resource "aws_route_table_association" "public_subnet_1b" {
  subnet_id      = aws_subnet.team4_public_subnet_1b.id
  route_table_id = aws_route_table.public.id
}


# Create an Elastic IP for the NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"
}

# Create a NAT Gateway
resource "aws_nat_gateway" "Team4" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.team4_public_subnet_1a.id

  tags = {
    Name = "team4-nat-gateway"
  }

  depends_on = [aws_internet_gateway.Team4] # Ensure the internet gateway is created before the NAT gateway
}

# Create a route table for the private subnet
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.Team4.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.Team4.id
  }

  tags = {
    Name = "private-route-table"
  }
}

# Associate the route table with the first private subnet
resource "aws_route_table_association" "private_subnet_1a" {
  subnet_id      = aws_subnet.team4_private_subnet_1a.id
  route_table_id = aws_route_table.private.id
}

# Associate the route table with the second ptivate subnet
resource "aws_route_table_association" "private_subnet_1b" {
  subnet_id      = aws_subnet.team4_private_subnet_1b.id
  route_table_id = aws_route_table.private.id
}
