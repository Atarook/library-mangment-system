provider "aws" {
  region = "us-west-2"
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = var.s3_bucket_name
  tags        = var.tags
}

module "network" {
  source              = "./modules/network"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  availability_zones  = ["us-west-2a", "us-west-2b"]
  tags                = var.tags
}

module "iam_roles" {
  source    = "./modules/iam_roles"
  user_arns = var.user_arns
  tags      = var.tags
}

module "eks" {
  source           = "./modules/eks"
  cluster_name     = "Team4-EKS"
  vpc_id           = module.network.vpc_id
  subnet_ids       = module.network.private_subnet_ids
  node_group_role_arn = module.iam_roles.eks_node_group_role_arn
  tags             = var.tags
}