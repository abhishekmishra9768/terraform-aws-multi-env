# S3 bucket for remote backend
resource "aws_s3_bucket" "remote_backend" {
  bucket = "terraform-aws-multi-env-remote-backend-2026"

  tags = {
    Name        = "terraform-remote-backend"
    Environment = "bootstrap"
  }
}
