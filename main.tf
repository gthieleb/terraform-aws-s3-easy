locals {
  effective_iam_user_name = var.iam_user_name != "" ? var.iam_user_name : "${var.bucket_prefix}-s3"
  bucket_names = {
    for key, value in var.buckets : key => key == "hcv-tf-state" ? "${key}-${random_id.bucket_suffix.hex}" : "${var.bucket_prefix}-${key}-${random_id.bucket_suffix.hex}"
  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 4.0"

  for_each = var.buckets

  bucket = local.bucket_names[each.key]

  control_object_ownership = true
  object_ownership         = "BucketOwnerEnforced"

  versioning = {
    enabled = each.value.versioning
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  tags = merge(var.tags, {
    Name        = local.bucket_names[each.key]
    Environment = var.bucket_prefix
    Purpose     = each.value.purpose
  })
}

resource "aws_iam_user" "s3" {
  name = local.effective_iam_user_name
  tags = var.tags
}

resource "aws_iam_access_key" "s3" {
  user = aws_iam_user.s3.name
}

resource "aws_iam_user_policy" "s3" {
  name = "${local.effective_iam_user_name}-policy"
  user = aws_iam_user.s3.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowS3Access"
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListBucket",
          "s3:GetBucketVersioning"
        ]
        Resource = flatten([
          for bucket in module.s3_bucket : [
            bucket.s3_bucket_arn,
            "${bucket.s3_bucket_arn}/*"
          ]
        ])
      }
    ]
  })
}

moved {
  from = aws_iam_user.vault_s3
  to   = aws_iam_user.s3
}

moved {
  from = aws_iam_access_key.vault_s3
  to   = aws_iam_access_key.s3
}

moved {
  from = aws_iam_user_policy.vault_s3
  to   = aws_iam_user_policy.s3
}
