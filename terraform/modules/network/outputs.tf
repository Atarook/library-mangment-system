output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.Team4.id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = [
    aws_subnet.team4_public_subnet_1a.id,
    aws_subnet.team4_public_subnet_1b.id
  ]
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = [
    aws_subnet.team4_private_subnet_1a.id,
    aws_subnet.team4_private_subnet_1b.id
  ]
}
