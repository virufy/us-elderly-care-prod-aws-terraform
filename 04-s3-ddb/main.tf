# S3 for raw audio files
resource "aws_s3_bucket" "raw_audio" {
  bucket = "${var.project}-${var.env}-raw-audio"
}

# Enable SSE-KMS
resource "aws_s3_bucket_server_side_encryption_configuration" "raw_audio" {
  bucket = aws_s3_bucket.raw_audio.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.s3_bucket_key.arn
    }
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "raw_audio" {
  bucket                  = aws_s3_bucket.raw_audio.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# DynamoDB for metadata
resource "aws_dynamodb_table" "metadata" {
  name         = "${var.project}-${var.env}-metadata"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "PatientID"

  attribute {
    name = "PatientID"
    type = "S"
  }

  server_side_encryption {
    enabled = true
  }
}
