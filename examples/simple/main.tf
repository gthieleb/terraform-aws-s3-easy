terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

module "s3_easy" {
  source = "../.."

  workspace_name = "dev"
  tags = {
    Project   = "terraform-aws-s3-easy"
    ManagedBy = "terraform"
  }
}

output "bucket_names" {
  value = module.s3_easy.bucket_names
}
