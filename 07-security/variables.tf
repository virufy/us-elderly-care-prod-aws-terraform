variable "admin_role_arn" {
  description = "Admin role allowed to manage KMS keys"
  type        = string
}

variable "lambda_role_arn" {
  description = "Lambda execution role allowed to decrypt objects"
  type        = string
}
