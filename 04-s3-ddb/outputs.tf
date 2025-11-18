output "raw_audio_bucket_arn" {
  description = "ARN of the S3 bucket used for audio files"
  value       = aws_s3_bucket.raw_audio.arn
}

output "raw_audio_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.raw_audio.bucket
}

output "patient_data_table_arn" {
  description = "ARN of the DynamoDB table"
  value       = aws_dynamodb_table.metadata.arn
}
