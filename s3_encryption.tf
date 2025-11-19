resource "aws_s3_bucket_server_side_encryption_configuration" "raw_audio" {
  bucket = module.s3_ddb.raw_audio_bucket_id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.s3_bucket_key.arn
    }
  }
}


