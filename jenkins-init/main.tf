terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.65.0"
    }
  }

  #   backend "s3" {
  #     bucket = "kamal-state"
  #     key    = "terraform.tfstate"
  #     region = "eu-west-1"
  #   }
}


provider "aws" {
  region = "eu-west-1"
}


