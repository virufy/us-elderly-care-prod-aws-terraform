terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"  
    }
  }
}

# AWS Provider
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
  
  default_tags {
    tags = local.tags
  }
}
