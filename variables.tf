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

