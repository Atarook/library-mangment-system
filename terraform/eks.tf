# Create EKS Cluster
resource "aws_eks_cluster" "Team4" {
  name     = "team4-eks-cluster"
  role_arn  = aws_iam_role.eks.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.team4_private_subnet_1a.id,
      aws_subnet.team4_private_subnet_1b.id
    ]
    security_group_ids = [aws_security_group.eks.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_policy
  ]
}

# Create EKS Node Group
resource "aws_eks_node_group" "Team4" {
  cluster_name    = aws_eks_cluster.Team4.name
  node_group_name = "team4-node-group"
  node_role_arn   = aws_iam_role.eks_node_group.arn
  subnet_ids = [
      aws_subnet.team4_private_subnet_1a.id,
      aws_subnet.team4_private_subnet_1b.id
    ]
  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  remote_access {
    ec2_ssh_key               = "team4"  # Replace with your actual SSH key name
    source_security_group_ids = [aws_security_group.eks.id]  # Security group allowed to SSH
  }
}
