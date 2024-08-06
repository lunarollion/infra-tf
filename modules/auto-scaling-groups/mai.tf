
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"

      version = ">= 3.5, != 3.14.0, < 4.0"
    }
    template = {
      source = "hashicorp/template"
    }
    time = {
      source = "hashicorp/time"
    }
  }
}