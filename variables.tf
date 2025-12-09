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

variable "common_tags" {
  description = "Common tags to apply to all resources."
  type        = map(string)

  default = {
    ManagedBy         = "Terraform"
    Owner             = "Ray Kim"
    Team              = "AWS Cloud Engineering"
  }
}