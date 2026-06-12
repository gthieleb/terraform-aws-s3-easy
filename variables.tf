variable "region" {
  description = "AWS region used by module consumers when configuring resources."
  type        = string
  default     = "eu-central-1"
}

variable "buckets" {
  description = "Map of S3 buckets to create."
  type = map(object({
    purpose    = string
    versioning = bool
  }))
  default = {
    hcv-backup = {
      purpose    = "Vault backup storage"
      versioning = false
    }
    hcv-tf-state = {
      purpose    = "Terraform state storage"
      versioning = true
    }
  }
}

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  default = {
    ManagedBy = "terraform"
  }
}

variable "bucket_prefix" {
  description = "Prefix used for bucket names and IAM resources."
  type        = string
}

variable "iam_user_name" {
  description = "Name of the IAM user created for bucket access. Defaults to '{bucket_prefix}-s3'."
  type        = string
  default     = ""
}
