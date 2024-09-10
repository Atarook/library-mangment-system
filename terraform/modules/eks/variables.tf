variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "The IDs of the subnets"
  type        = list(string)
}

variable "node_group_role_arn" {
  description = "ARN of the node group role"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}
