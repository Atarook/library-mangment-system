# Create EKS Cluster
resource "aws_iam_openid_connect_provider" "eks" {
  url             = aws_eks_cluster.Team4.identity.0.oidc.0.issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.oidc.certificates[0].sha1_fingerprint]
}


provider "tls" {}

data "tls_certificate" "oidc" {
  url = aws_eks_cluster.Team4.identity[0].oidc[0].issuer
}


resource "aws_eks_cluster" "Team4" {
  name     = "team4-eks-cluster"
  role_arn = aws_iam_role.eks.arn

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
    ec2_ssh_key               = "team4"                     # Replace with your actual SSH key name
    source_security_group_ids = [aws_security_group.eks.id] # Security group allowed to SSH
  }
}






# CoreDNS Add-on
resource "aws_eks_addon" "coredns" {
  cluster_name  = aws_eks_cluster.Team4.name
  addon_name    = "coredns"
  addon_version = "v1.11.1-eksbuild.8"
}

# kube-proxy Add-on
resource "aws_eks_addon" "kube_proxy" {
  cluster_name  = aws_eks_cluster.Team4.name
  addon_name    = "kube-proxy"
  addon_version = "v1.30.0-eksbuild.3"
}

# VPC CNI Add-on
resource "aws_eks_addon" "vpc_cni" {
  cluster_name  = aws_eks_cluster.Team4.name
  addon_name    = "vpc-cni"
  addon_version = "v1.18.3-eksbuild.2"
}







# IAM
resource "aws_iam_role" "ebs_csi_driver" {
  name               = "ebs-csi-driver"
  assume_role_policy = data.aws_iam_policy_document.ebs_csi_driver_assume_role.json
}

data "aws_iam_policy_document" "ebs_csi_driver_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
    }

    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]

    condition {
      test     = "StringEquals"
      variable = "${aws_iam_openid_connect_provider.eks.url}:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "${aws_iam_openid_connect_provider.eks.url}:sub"
      values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
    }

  }
}






# Attach the Amazon EKS Worker Node Policy to the IAM role
resource "aws_iam_role_policy_attachment" "_node_group_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.ebs_csi_driver.name
}

# Attach the Amazon EC2 Container Registry Read-Only Policy to the IAM role
resource "aws_iam_role_policy_attachment" "_node_group_ecr" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.ebs_csi_driver.name
}

# Attach the Amazon EKS CNI Policy to the IAM role
resource "aws_iam_role_policy_attachment" "_node_group_cni" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.ebs_csi_driver.name
}

# Attach the Amazon EC2 Container Registry Full Access Policy to the IAM role
resource "aws_iam_role_policy_attachment" "_node_group_ContainerRegistryFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
  role       = aws_iam_role.ebs_csi_driver.name
}

# Attach the Amazon EC2 Full Access Policy to the IAM role
resource "aws_iam_role_policy_attachment" "_node_group_FullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  role       = aws_iam_role.ebs_csi_driver.name
}

# Attach the Amazon EBS CSI Driver Policy to the IAM role
resource "aws_iam_role_policy_attachment" "_node_group_ebs_csi" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.ebs_csi_driver.name
}






# EBS CSI Driver Add-on
resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name             = aws_eks_cluster.Team4.name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = "v1.29.1-eksbuild.1"
  service_account_role_arn = aws_iam_role.ebs_csi_driver.arn
}
