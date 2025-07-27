terraform {
  backend "s3" {
    bucket  = "mohan-custom-terraform-dev"
    key     = "vpc/dev"
    region  = "us-east-2"
    encrypt = true # Optional: enable encryption
    # dynamodb_table = "terraform-locks" # Optional: for state locking
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }  
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }

  }
}

provider "aws" {
  region  = "us-east-2"
  profile = "default"
}