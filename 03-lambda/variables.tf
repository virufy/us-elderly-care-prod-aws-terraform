variable "project" {
  type = string
}

variable "env" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "s3_bucket_arn" {
  type = string
}

variable "s3_bucket_name" {
  type = string
}

variable "dynamodb_table_arn" {
  type = string
}

