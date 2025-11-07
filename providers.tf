variable "aws_profile" {
  type    = string
  default = "mothership-prod"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

provider "aws" {
  region  = var.region
  profile = var.aws_profile
}