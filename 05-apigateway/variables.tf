variable "project" {
  type = string
}

variable "env" {
  type = string
}

#For Lambda permission
variable "lambda_arn" {
  type = string
}

#For HTTP API -> Lambda
variable "lambda_invoke_arn" {
  type = string
}

variable "region" {
  type    = string
  default = "us-east-1"
}