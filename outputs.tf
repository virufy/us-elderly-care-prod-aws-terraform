output "raw_audio_bucket_arn" {
  value = module.s3_ddb.raw_audio_bucket_arn
}

output "raw_audio_bucket_name" {
  value = module.s3_ddb.raw_audio_bucket_name
}

output "patient_data_table_arn" {
  value = module.s3_ddb.patient_data_table_arn
}
