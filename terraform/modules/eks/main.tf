resource "aws_eks_cluster" "Team4_EKS" {
  name     = var.cluster_name
  role_arn = module.iam_roles.eks_role_arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  tags = var.tags
}

resource "aws_eks_node_group" "Team4_EKS_Nodes" {
  cluster_name    = aws_eks_cluster.Team4_EKS.name
  node_role_arn   = var.node_group_role_arn
  subnet_ids      = var.subnet_ids
  scaling_config {
    desired_size = 3
    max_size     = 5
    min_size     = 1
  }
  tags = var.tags
}
