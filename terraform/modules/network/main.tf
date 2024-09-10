resource "aws_vpc" "Team4" {
  cidr_block = var.vpc_cidr
  tags       = var.tags
}

resource "aws_subnet" "team4_public_subnet_1a" {
  vpc_id            = aws_vpc.Team4.id
  cidr_block        = var.public_subnet_cidrs[0]
  availability_zone = var.availability_zones[0]
  map_public_ip_on_launch = true
  tags             = var.tags
}

resource "aws_subnet" "team4_public_subnet_1b" {
  vpc_id            = aws_vpc.Team4.id
  cidr_block        = var.public_subnet_cidrs[1]
  availability_zone = var.availability_zones[1]
  map_public_ip_on_launch = true
  tags             = var.tags
}

resource "aws_subnet" "team4_private_subnet_1a" {
  vpc_id            = aws_vpc.Team4.id
  cidr_block        = var.private_subnet_cidrs[0]
  availability_zone = var.availability_zones[0]
  tags              = var.tags
}

resource "aws_subnet" "team4_private_subnet_1b" {
  vpc_id            = aws_vpc.Team4.id
  cidr_block        = var.private_subnet_cidrs[1]
  availability_zone = var.availability_zones[1]
  tags              = var.tags
}
