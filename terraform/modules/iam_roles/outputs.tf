output "eks_node_group_role_arn" {
  description = "The ARN of the EKS node group role"
  value       = aws_iam_role.eks_node_group_role.arn
}
