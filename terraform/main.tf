# Terraform configuration block for the backend
terraform {
  backend "s3" {
    bucket         = "team4-state"  # S3 bucket name where the Terraform state file will be stored
    key            = "state/terraform.tfstate"  # Path within the S3 bucket to store the state file
    region         = "eu-west-1"  # AWS region where the S3 bucket is located
    encrypt        = true  # Enable encryption for the state file stored in S3

    # Optional: Uncomment the following line to use a DynamoDB table for state locking
    # dynamodb_table = "terraform-locks"  # DynamoDB table for state locking to prevent simultaneous updates
  }
}

# AWS provider configuration
provider "aws" {
  region = "eu-west-1"  # Set the AWS region for all AWS resources to be created in this region
}

# Kubernetes provider configuration
provider "kubernetes" {
  host                   = aws_eks_cluster.Team4.endpoint
  token                  = data.aws_eks_cluster_auth.Team4.token
  cluster_ca_certificate = base64decode(aws_eks_cluster.Team4.certificate_authority.0.data)
}
