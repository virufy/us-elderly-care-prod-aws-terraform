# GLOBAL VARIABLES

variable "project" {
    type = string
    default = "mothership"
}

variable "env" {
    type = string
    default = "prod"
}

variable "azs" {
    type = list(string)
    default = ["us-east-1a", "us-east-1b" ]
}

variable "admin_role_arn" {
  description = "Admin role allowed to manage KMS keys"
  type        = string
}

variable "lambda_role_arn" {
  description = "Lambda execution role allowed to decrypt S3 objects"
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply to all resources."
  type        = map(string)

  default = {
    ManagedBy         = "Terraform"
    Owner             = "Ray Kim"
    Team              = "AWS Cloud Engineering"
  }
}