output "s3_bucket_names" {
  value       = aws_s3_bucket.my_bucket[*].bucket
  description = "Names of the S3 buckets"
}
