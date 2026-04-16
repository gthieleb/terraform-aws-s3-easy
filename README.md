# terraform-aws-s3-easy

Reusable Terraform module for provisioning opinionated S3 buckets plus a dedicated IAM user and access key for bucket access.

## Usage

```hcl
provider "aws" {
  region = "eu-central-1"
}

module "s3_easy" {
  source = "gthieleb/s3-easy/aws"

  workspace_name = "prod"

  buckets = {
    hcv-backup = {
      purpose    = "Vault backup storage"
      versioning = false
    }
    hcv-tf-state = {
      purpose    = "Terraform state storage"
      versioning = true
    }
  }

  tags = {
    Project   = "hashicorp-vault-setup"
    ManagedBy = "terraform"
  }
}
```

## Features

- Creates one S3 bucket per entry in `buckets`
- Adds a random bucket suffix to keep names globally unique
- Prefixes non-state buckets with `workspace_name`
- Enables AES256 default encryption and blocks all public access
- Creates a dedicated IAM user, access key, and inline policy for the buckets

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `region` | AWS region used by module consumers when configuring resources. | `string` | `"eu-central-1"` | no |
| `buckets` | Map of S3 buckets to create. | `map(object({ purpose = string, versioning = bool }))` | see `variables.tf` | no |
| `tags` | Tags to apply to all resources. | `map(string)` | `{ ManagedBy = "terraform" }` | no |
| `workspace_name` | Workspace or environment name used to prefix non-state bucket names and IAM resources. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| `bucket_names` | Names of created S3 buckets. |
| `bucket_arns` | ARNs of created S3 buckets. |
| `iam_user_name` | Name of the IAM user created for bucket access. |
| `access_key_id` | AWS access key ID for the dedicated IAM user. |
| `secret_access_key` | AWS secret access key for the dedicated IAM user. Sensitive. |

## Example

See [`examples/simple`](./examples/simple) for a minimal working configuration.
