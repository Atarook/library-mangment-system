# Create a security group for the EKS cluster
resource "aws_security_group" "eks" {
  vpc_id = aws_vpc.Team4.id  # The VPC where the security group will be created

  # Allow inbound HTTP traffic on port 80 from any IP address
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow from anywhere
  }

  # Allow inbound traffic on port 8080 from any IP address
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow from anywhere
  }

  # Allow all outbound traffic from the security group to any IP address
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # "-1" signifies all protocols
    cidr_blocks = ["0.0.0.0/0"]  # Allow to anywhere
  }

  # Add a tag to the security group for identification
  tags = {
    Name = "eks-sg"  # Name of the security group
  }
}

# Create an IAM role for the EKS cluster
resource "aws_iam_role" "eks" {
  name = "eks-cluster-role-team4"  # Name of the IAM role

  # Define the trust policy allowing EKS to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"  # The service that can assume this role (EKS)
        }
      }
    ]
  })
}

# Attach the Amazon EKS Cluster Policy to the IAM role
resource "aws_iam_role_policy_attachment" "eks_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"  # EKS Cluster Policy
  role       = aws_iam_role.eks.name  # Attach to the previously created role
}

# Create an IAM role for the EKS Node Group
resource "aws_iam_role" "eks_node_group" {
  name = "team4-eks-node-group-role"  # Name of the IAM role for the Node Group

  # Define the trust policy allowing EC2 instances to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"  # The service that can assume this role (EC2)
        }
      }
    ]
  })
}

# Attach the Amazon EKS Worker Node Policy to the IAM role
resource "aws_iam_role_policy_attachment" "eks_node_group_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"  # EKS Worker Node Policy
  role       = aws_iam_role.eks_node_group.name  # Attach to the Node Group role
}

# Attach the Amazon EC2 Container Registry Read-Only Policy to the IAM role
resource "aws_iam_role_policy_attachment" "eks_node_group_ecr" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"  # ECR Read-Only Policy
  role       = aws_iam_role.eks_node_group.name  # Attach to the Node Group role
}

# Attach the Amazon EKS CNI Policy to the IAM role
resource "aws_iam_role_policy_attachment" "eks_node_group_cni" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"  # EKS CNI Policy
  role       = aws_iam_role.eks_node_group.name  # Attach to the Node Group role
}
# Attach the Amazon EKS CNI Policy to the IAM role
resource "aws_iam_role_policy_attachment" "eks_node_group_ContainerRegistryFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"  # EKS CNI Policy
  role       = aws_iam_role.eks_node_group.name  # Attach to the Node Group role
}
# Attach the Amazon EKS CNI Policy to the IAM role
resource "aws_iam_role_policy_attachment" "eks_node_group_FullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"  # EKS CNI Policy
  role       = aws_iam_role.eks_node_group.name  # Attach to the Node Group role
}
# IAM Role for Master Access to EKS
resource "aws_iam_role" "master_access_team_4" {
  name               = "team4-masterPermissionRole"  # Name of the IAM role for master access
  assume_role_policy = data.aws_iam_policy_document.trusted_account.json  # Trust policy allowing a specific account to assume this role
  tags               = var.tags  # Tags for the IAM role
}



resource "aws_iam_policy" "ec2_permissions_policy" {
  name        = "EC2PermissionsForNodeGroup"
  description = "EC2 permissions to attach and detach volumes, describe volumes, and more."

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ec2:AttachVolume",
          "ec2:DetachVolume",
          "ec2:DescribeInstances",
          "ec2:DescribeVolumes",
          "ec2:DescribeVolumeStatus",
          "ec2:DescribeTags",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeVolumesModifications",
          "ec2:ModifyVolume",
          "ec2:CreateVolume",
          "ec2:CreateTags"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_node_group_ec2_permissions" {
  policy_arn = aws_iam_policy.ec2_permissions_policy.arn  # Use the EC2 policy you just created
  role       = aws_iam_role.eks_node_group.name           # Attach to the Node Group role
}


resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = jsonencode([{
      rolearn  = aws_iam_role.eks_node_group.arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:bootstrappers", "system:nodes"]
    }])

    mapUsers = jsonencode([{
      userarn  = "arn:aws:iam::637423483309:user/fawzy"
      username = "fawzy"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::637423483309:user/ahmedkamal"
      username = "ahmedkamal"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::637423483309:user/Tarek"
      username = "Tarek"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::637423483309:user/ahmed"
      username = "ahmed"
      groups   = ["system:masters"]
    }
    
    ])
  }
}