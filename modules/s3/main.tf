# S3
resource "aws_s3_bucket" "my_bucket" {
  count  = var.s3_count
  bucket = "${var.env}-my-bucket-2026-${count.index}"

  tags = {
    Name = "${var.env}-my-bucket-${count.index}"
  }
}
