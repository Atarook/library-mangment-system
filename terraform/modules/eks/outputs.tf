output "eks_cluster_id" {
  description = "The ID of the EKS cluster"
  value       = aws_eks_cluster.Team4_EKS.id
}
