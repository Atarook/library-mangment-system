resource "aws_iam_role" "eks_node_group_role" {
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role_policy.json
  tags               = var.tags
}

resource "aws_iam_policy_document" "eks_assume_role_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_policy_attachment" "eks_node_group_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  roles      = [aws_iam_role.eks_node_group_role.name]
}
