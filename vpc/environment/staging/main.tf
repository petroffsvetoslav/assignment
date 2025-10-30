terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.9.0"

  backend "s3" {
    bucket  = "demo-staging-tfstates"
    key     = "vpc.tfstate"
    region  = "eu-south-1"
    encrypt = true
  }
}

provider "aws" {
  region = "eu-south-1"

  default_tags {
    tags = {
      ENV  = "staging"
      Name = "demo"
    }
  }
}

module "demo" {
  source               = "../../infra"
  name                 = "demo"
  env                  = "staging"
  vpc_cidr             = "172.16.0.0/16"
  public_subnet_cidrs  = ["172.16.0.0/20", "172.16.16.0/20"]
  private_subnet_cidrs = ["172.16.48.0/20", "172.16.64.0/20"]
  region               = "eu-south-1"
  availability_zones   = ["eu-south-1a", "eu-south-1b"]
}
