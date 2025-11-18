terraform {
  backend "s3" {
    bucket = "mothership-terraform-state-dev"
    key    = "prod/terraform.tfstate"
    region = "us-east-1"
    encrypt = true

  }
}
