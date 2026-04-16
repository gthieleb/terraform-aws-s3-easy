output "bucket_names" {
  description = "Names of created S3 buckets."
  value       = { for k, v in module.s3_bucket : k => v.s3_bucket_id }
}

output "bucket_arns" {
  description = "ARNs of created S3 buckets."
  value       = { for k, v in module.s3_bucket : k => v.s3_bucket_arn }
}

output "iam_user_name" {
  description = "Name of the IAM user created for bucket access."
  value       = aws_iam_user.vault_s3.name
}

output "access_key_id" {
  description = "AWS access key ID for the dedicated IAM user."
  value       = aws_iam_access_key.vault_s3.id
}

output "secret_access_key" {
  description = "AWS secret access key for the dedicated IAM user."
  value       = aws_iam_access_key.vault_s3.secret
  sensitive   = true
}
